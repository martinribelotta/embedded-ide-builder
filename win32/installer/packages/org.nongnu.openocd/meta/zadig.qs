function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
            "@TargetDir@/openocd/zadig_2.2.exe",
            "@StartMenuDir@/Zadig Driver Manager.lnk",
            "workingDirectory=@TargetDir@");
        component.addOperation("CreateShortcut",
            "@TargetDir@/openocd/drivers/UsbDriverTool.exe",
            "@StartMenuDir@/USB Driver Tool.lnk",
            "workingDirectory=@TargetDir@");
    }
}
