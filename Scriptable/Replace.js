// Variables used by Scriptable.
// These must be at the very top of the file. Do not edit.
// icon-color: blue; icon-glyph: magic;

// 获取用户输入的替换内容
async function getUserInput() {
    let alert = new Alert();
    alert.title = '内容替换工具';
    alert.addTextField('请输入要替换的内容', '');
    alert.addTextField('请输入新的内容', '');
    alert.addAction('确认');
    alert.addCancelAction('取消');

    let selectedIndex = await alert.presentAlert();
    if (selectedIndex === -1) {
        console.log('操作已取消');
        return null;
    }

    let oldText = alert.textFieldValue(0);
    let newText = alert.textFieldValue(1);

    if (!oldText || !newText) {
        console.error('替换内容不能为空');
        return null;
    }

    return { 'oldText': oldText, 'newText': newText };
}

// 替换文件内容
async function replaceFileContent(filePaths, oldText, newText) {
    const fileManager = FileManager.iCloud();
    for (let filePath of filePaths) {
        if (!fileManager.isFileStoredIniCloud(filePath)) {
            await fileManager.downloadFileFromiCloud(filePath);
        }

        let fileContent = fileManager.readString(filePath);
        if (!fileContent) continue;

        let updatedContent = fileContent.replace(new RegExp(oldText, 'g'), newText);
        fileManager.writeString(filePath, updatedContent);
        console.log(`✅ 已替换文件: ${filePath}`);
    }
}

// 主函数
async function main() {
    let userInput = await getUserInput();
    if (!userInput) return;

    const { oldText, newText } = userInput;
    let selectedFiles;

    try {
        selectedFiles = await DocumentPicker.openFile();
    } catch (error) {
        console.log('用户取消了文件选择操作');
        return;
    }

    if (!selectedFiles) {
        console.log('未选择任何文件，操作已取消');
        return;
    }

    if (!Array.isArray(selectedFiles)) {
        selectedFiles = [selectedFiles];
    }

    const fileManager = FileManager.iCloud();
    selectedFiles = selectedFiles.filter(filePath => fileManager.fileExists(filePath));

    if (selectedFiles.length === 0) {
        console.error('选择的文件不存在于iCloud中');
        return;
    }

    await replaceFileContent(selectedFiles, oldText, newText);

    let completionAlert = new Alert();
    completionAlert.title = '替换完成';
    completionAlert.message = `已完成对 ${selectedFiles.length} 个文件的替换操作。`;
    completionAlert.addAction('确定');
    await completionAlert.presentAlert();
}

// 运行主函数
await main();