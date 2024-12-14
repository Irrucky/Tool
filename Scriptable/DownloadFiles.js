// Variables used by Scriptable.
// These must be at the very top of the file. Do not edit.
// icon-color: blue; icon-glyph: magic;

// 将非法字符替换为下划线
function sanitizeFileName(fileName) {
    return fileName.replace(/[\/:*?"<>|]/g, '_');
}

// 处理文件下载
async function downloadFile(url, savePath) {
    try {
        let request = new Request(url);
        let fileContent = await request.load();
        const fileManager = FileManager.iCloud();
        fileManager.write(savePath, fileContent);
        console.log('✅ 下载成功: ' + savePath);
    } catch (error) {
        console.error('❌ 下载失败: ' + error.message);
    }
}

// 弹出下载链接和文件名输入框
async function promptForDownloadInfo() {
    let alert = new Alert();
    alert.title = '文件下载';
    alert.addTextField('下载链接', '');
    alert.addTextField('文件名（可选）', '');
    alert.addAction('下载');
    alert.addCancelAction('取消');

    let userChoice = await alert.presentAlert();
    if (userChoice === -1) {
        console.log('操作已取消');
        return null;
    }

    let downloadUrl = alert.textFieldValue(0).trim();
    if (!downloadUrl) {
        console.log('❌ 下载链接不能为空');
        return null;
    }

    let fileName = alert.textFieldValue(1).trim() || sanitizeFileName(downloadUrl.split('?')[0].split('/').pop());
    return { url: downloadUrl, fileName: fileName };
}

// 主函数
async function main() {
    let downloadInfo = await promptForDownloadInfo();
    if (!downloadInfo) return;

    const { url, fileName } = downloadInfo;
    const fileManager = FileManager.iCloud();

    let folderPath = await DocumentPicker.openFolder();
    if (!folderPath) {
        console.log('❌ 选择文件夹操作取消');
        return; // 退出脚本
    }

    let savePath = fileManager.joinPath(folderPath, fileName);
    await downloadFile(url, savePath);

    let successAlert = new Alert();
    successAlert.title = '下载成功';
    successAlert.message = '文件已保存至 iCloud: ' + fileName;
    successAlert.addAction('确定');
    await successAlert.presentAlert();
}

// 运行主函数
await main();