var purpleBox = null, greenBox=null, orangeBox=null, redBox=null, zoomBox=null;
zebra.ready(function()
{
	imageProject = zebra.ui.loadImage("Left.png");
	imageLibrary = zebra.ui.loadImage("Right.png");
	imageTutorial = zebra.ui.loadImage("Top.png");
	imageWorkspace = zebra.ui.loadImage("Bottom.png");
});

zebra.ready(function()
{
    eval(zebra.Import("ui", "layout"));

	//CANVAS
	var canvas = new zCanvas("zebra-canvas");
	var root = canvas.root;
	canvas.fullScreen();
	root.setBackground("rgba(0,0,0,0)");
	root.setLayout(zg_layout);
	
	
	//PULL OUT PANELS
	
	
	
	
	//Project
    var panelProject = new $zg_PulloutPanel();
    panelProject.setBackground(new Picture(imageProject));
    root.add(new zg_pulloutPanel_Constr(LEFT, 0.728, 0.074, 0.656, 0.886, 0.125, 0.296), panelProject);
	
	//Library
	var panelLibrary = new $zg_PulloutPanel();
    panelLibrary.setBackground(new Picture(imageLibrary));
    root.add(new zg_pulloutPanel_Constr(RIGHT, 0.728, 0.074, 0.500, 0.886, 0.579, 0.296), panelLibrary);

	//Tutorial
	var panelTutorial = new $zg_PulloutPanel();
    panelTutorial.setBackground(new Picture(imageTutorial));
    root.add(new zg_pulloutPanel_Constr(TOP, 0.39, 0.328, 0.226, 0.886, 0.579, 0.296), panelTutorial);

	//Workspace
	var panelWorkspace = new $zg_PulloutPanel();
    panelWorkspace.setBackground(new Picture(imageWorkspace));
    root.add(new zg_pulloutPanel_Constr(BOTTOM, 0.30, 0.40, 0.15, 0.886, 0.125, 0.296), panelWorkspace);
});