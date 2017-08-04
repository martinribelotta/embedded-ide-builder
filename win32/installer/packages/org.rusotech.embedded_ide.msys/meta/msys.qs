function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
            "@TargetDir@/msys/msys.bat",
            "@StartMenuDir@/Embedded IDE Console.lnk",
            "workingDirectory=@TargetDir@",
            "iconPath=@TargetDir@/embedded-ide/embedded-ide.exe");
    }
}
