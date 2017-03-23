function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
            "@TargetDir@/start-ide.bat",
            "@StartMenuDir@/Embedded IDE Workspace.lnk",
            "workingDirectory=@TargetDir@",
            "iconPath=@TargetDir@/embedded-ide/embedded-ide.exe");
    }
}
