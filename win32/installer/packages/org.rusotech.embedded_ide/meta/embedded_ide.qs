function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
            "@TargetDir@/embedded-ide/embedded-ide.exe",
            "@StartMenuDir@/Embedded IDE.lnk",
            "workingDirectory=@TargetDir@");
        component.addOperation("CreateShortcut",
            "@TargetDir@/maintenancetool.exe",
            "@StartMenuDir@/Uninstall.lnk",
            "workingDirectory=@TargetDir@");
    }
}
