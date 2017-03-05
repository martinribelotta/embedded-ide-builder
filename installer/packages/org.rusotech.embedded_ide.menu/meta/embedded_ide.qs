function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
            "@TargetDir@/embedded-ide/embedded-ide.exe",
            "@StartMenuDir@/Embedded IDE Stand Alone.lnk",
            "workingDirectory=@TargetDir@");
    }
}
