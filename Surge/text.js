/*
 * 由@mieqq编写
 * 原脚本地址：https://raw.githubusercontent.com/mieqq/mieqq/master/sub_info_panel.js
 * 由@Rabbit-Spec修改
 * 更新日期：2022.08.24
 * 版本：1.5
*/

let args = getArgs(); // 获取脚本参数

(async () => {
  let info = await getDataInfo(encodeURL(args.url)); // 获取流量信息
  if (!info) $done(); // 如果没有获取到信息，结束脚本
  let resetDayLeft = getRmainingDays(parseInt(args["reset_day"])); // 获取剩余重置天数

  let used = info.download + info.upload; // 已用流量
  let total = info.total; // 总流量
  let expire = args.expire || info.expire; // 到期时间
  let content = [`用量：${bytesToSize(used)} | ${bytesToSize(total)}`]; // 流量信息

  if (resetDayLeft) {
    content.push(`重置：剩余${resetDayLeft}天`); // 重置天数信息
  }
  if (expire && expire !== "false") {
    if (/^[\d.]+$/.test(expire)) expire *= 1000; // 如果到期时间是数字，则转换为毫秒
    content.push(`到期：${formatTime(expire)}`); // 添加到期时间信息
  }

  let now = new Date();
  let hour = now.getHours();
  let minutes = now.getMinutes();
  hour = hour > 9 ? hour : "0" + hour;
  minutes = minutes > 9 ? minutes : "0" + minutes;

  $done({
    title: `${args.title} | ${hour}:${minutes}`, // 标题包含当前时间
    content: content.join("\n"), // 内容包含流量信息
    icon: args.icon || "airplane.circle", // 图标
    "icon-color": args.color || "#007aff", // 图标颜色
  });
})();

function getArgs() {
  return Object.fromEntries(
    $argument
      .split("&")
      .map((item) => item.split("="))
      .map(([k, v]) => [k, decodeURIComponent(v)])
  );
}

function getUserInfo(url) {
  let method = args.method || "head"; // 请求方法
  let request = { headers: { "User-Agent": "Quantumult%20X" }, url };
  return new Promise((resolve, reject) =>
    $httpClient[method](request, (err, resp) => {
      if (err != null) {
        reject(err);
        return;
      }
      if (resp.status !== 200) {
        reject(resp.status);
        return;
      }
      let header = Object.keys(resp.headers).find(
        (key) => key.toLowerCase() === "subscription-userinfo"
      );
      if (header) {
        resolve(resp.headers[header]);
        return;
      }
      reject("链接响应头不带有流量信息");
    })
  );
}

async function getDataInfo(url) {
  const [err, data] = await getUserInfo(url)
    .then((data) => [null, data])
    .catch((err) => [err, null]);
  if (err) {
    console.log(err);
    return;
  }

  return Object.fromEntries(
    data
      .match(/\w+=[\d.eE+-]+/g)
      .map((item) => item.split("="))
      .map(([k, v]) => [k, Number(v)])
  );
}

function getRmainingDays(resetDay) {
  if (!resetDay) return;

  let now = new Date();
  let today = now.getDate();
  let month = now.getMonth();
  let year = now.getFullYear();
  let daysInMonth;

  if (resetDay > today) {
    daysInMonth = 0;
  } else {
    daysInMonth = new Date(year, month + 1, 0).getDate();
  }

  return daysInMonth - today + resetDay;
}

function bytesToSize(bytes) {
  if (bytes === 0) return "0B";
  let k = 1024;
  sizes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  let i = Math.floor(Math.log(bytes) / Math.log(k));
  return (bytes / Math.pow(k, i)).toFixed(2) + " " + sizes[i];
}

function formatTime(time) {
  let dateObj = new Date(time);
  let year = dateObj.getFullYear();
  let month = dateObj.getMonth() + 1;
  let day = dateObj.getDate();
  return year + "年" + month + "月" + day + "日";
}

function encodeURL(url) {
  return encodeURIComponent(url);
}
