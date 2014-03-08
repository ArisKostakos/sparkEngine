eval(zebra.Import("ui", "layout"));

//MAIN LAYOUT

var zg_layout = new Layout
([
	function calcPreferredSize(t)
	{
		return { width: 0, height:0 }; // just a stub                             
	},

	function doLayout(t)
	{
		for (var i = 0; i < t.kids.length; i++)
		{
			var kid = t.kids[i];
			if (kid.isVisible === true)
			{
				var ctr = kid.constraints;
				if (ctr.alignment == LEFT)
				{
					var ps = kid.getPreferredSize();
					ps.height = ~~(t.height*ctr.percentage);
					ps.width = ps.height*ctr.aspectRatio;
					kid.setSize(ps.width, ps.height);
					var y = ~~(t.height*ctr.offset);
					var x = (kid.state == "hidden") ? -ps.width*ctr.hiddenPercentage : 0;
					kid.setLocation(x,y);
				}
				else if (ctr.alignment == RIGHT)
				{
					var ps = kid.getPreferredSize();
					ps.height = ~~(t.height*ctr.percentage);
					ps.width = ps.height*ctr.aspectRatio;
					kid.setSize(ps.width, ps.height);
					var y = ~~(t.height*ctr.offset);
					var x = (kid.state == "hidden") ? t.width-ps.width + ps.width*ctr.hiddenPercentage : t.width-ps.width;
					kid.setLocation(x,y);
				}
				else if (ctr.alignment == TOP)
				{
					var ps = kid.getPreferredSize();
					ps.width = ~~(t.width*ctr.percentage);
					ps.height = ps.width*ctr.aspectRatio;
					kid.setSize(ps.width, ps.height);
					var x = ~~(t.width*ctr.offset);
					var y = (kid.state == "hidden") ? -ps.height*ctr.hiddenPercentage : 0;
					kid.setLocation(x,y);
				}
				else if (ctr.alignment == BOTTOM)
				{
					var ps = kid.getPreferredSize();
					ps.width = ~~(t.width*ctr.percentage);
					ps.height = ps.width*ctr.aspectRatio;
					kid.setSize(ps.width, ps.height);
					var x = ~~(t.width*ctr.offset);
					var y = (kid.state == "hidden") ? t.height-ps.height + ps.height*ctr.hiddenPercentage : t.height-ps.height;
					kid.setLocation(x,y);
				}
			}
		}
	}
])

//PULLOUT PANELS

var $zg_PulloutPanel;

function zg_pulloutPanel_Constr(alignment, percentage, offset, aspectRatio, hiddenPercentage, handleStart, handleSize)
	{
		this.alignment = alignment;
		this.percentage = percentage;
		this.offset = offset;
		this.aspectRatio = aspectRatio;
		this.hiddenPercentage = hiddenPercentage;
		this.handleStart = handleStart;
		this.handleSize = handleSize;
	};
	
pulloutPanel();
function pulloutPanel()
{
	$zg_PulloutPanel = new zebra.Class(Panel, MouseListener, [$prototype,mouseClicked,mouseDragStarted]);


	function $prototype()
	{
		this.state = "shown";
		this.timer = null;
	}

	function mouseDragStarted(e)
	{
		this.mouseClicked(e);
	}
	
	
	function mouseClicked(e)
	{
		if (this.timer == null)
		{
			var handleClicked=false;
			
			
			if (e.mask==MouseEvent.LEFT_BUTTON)
			{
				if (this.constraints.alignment==LEFT)
				{
					if (e.x>=this.constraints.hiddenPercentage*this.width &&
						e.y>=this.constraints.handleStart*this.height &&
						e.y<=this.constraints.handleStart*this.height+this.constraints.handleSize*this.height)
					{
						handleClicked=true;
					}
				}
				else if (this.constraints.alignment==RIGHT)
				{
					if (e.x<=this.width-this.constraints.hiddenPercentage*this.width &&
						e.y>=this.constraints.handleStart*this.height &&
						e.y<=this.constraints.handleStart*this.height+this.constraints.handleSize*this.height)
					{
						handleClicked=true;
					}
				}
				else if (this.constraints.alignment==TOP)
				{
					if (e.y>=this.constraints.hiddenPercentage*this.height &&
						e.x>=this.constraints.handleStart*this.width &&
						e.x<=this.constraints.handleStart*this.width+this.constraints.handleSize*this.width)
					{
						handleClicked=true;
					}
				}
				else if (this.constraints.alignment==BOTTOM)
				{
					if (e.y<=this.height-this.constraints.hiddenPercentage*this.height &&
						e.x>=this.constraints.handleStart*this.width &&
						e.x<=this.constraints.handleStart*this.width+this.constraints.handleSize*this.width)
					{
						handleClicked=true;
					}
				}
			}
			
			
			
			if (handleClicked)
			{
				this.initPosX = this.x;
				this.initPosY = this.y;
				this.dt      = 0.5;
				this.counter = 0;
					
				if (this.state == "hidden")
				{
					var $this = this;
					this.state   = "shown";
					this.timer =  setInterval(function()
					{
						var panelShown=false;
					
						if ($this.constraints.alignment==LEFT) {if ($this.x  >= $this.initPosX + $this.width*$this.constraints.hiddenPercentage) panelShown=true;}
						else if ($this.constraints.alignment==RIGHT) {if ($this.x  <= $this.initPosX - $this.width*$this.constraints.hiddenPercentage) panelShown=true;}
						else if ($this.constraints.alignment==TOP) {if ($this.y  >= $this.initPosY + $this.height*$this.constraints.hiddenPercentage) panelShown=true;}
						else if ($this.constraints.alignment==BOTTOM) {if ($this.y  <= $this.initPosY - $this.height*$this.constraints.hiddenPercentage) panelShown=true;}
						
						if (panelShown)
						{
							clearInterval($this.timer);
							$this.timer = null;
							
							if ($this.constraints.alignment==LEFT) $this.setLocation($this.initPosX + $this.width*$this.constraints.hiddenPercentage, $this.y);
							else if ($this.constraints.alignment==RIGHT) $this.setLocation($this.initPosX - $this.width*$this.constraints.hiddenPercentage, $this.y);
							else if ($this.constraints.alignment==TOP) $this.setLocation($this.x, $this.initPosY + $this.height*$this.constraints.hiddenPercentage);
							else if ($this.constraints.alignment==BOTTOM) $this.setLocation($this.x, $this.initPosY - $this.height*$this.constraints.hiddenPercentage);
						}
						else
						{
							if ($this.constraints.alignment==LEFT) $this.setLocation($this.x + $this.dt, $this.y);
							else if ($this.constraints.alignment==RIGHT) $this.setLocation($this.x - $this.dt, $this.y);
							else if ($this.constraints.alignment==TOP) $this.setLocation($this.x, $this.y + $this.dt);
							else if ($this.constraints.alignment==BOTTOM) $this.setLocation($this.x, $this.y - $this.dt);
							
							$this.counter++;
							if ($this.counter % 10 === 0) $this.dt = $this.dt*2;
						}
					}, 1);
				}
				else
				{
					var $this = this;
					this.state   = "hidden";
					this.timer =  setInterval(function() 
					{
						var panelHidden=false;
						
						if ($this.constraints.alignment==LEFT) {if ($this.x  <= $this.initPosX - $this.width*$this.constraints.hiddenPercentage) panelHidden=true;}
						else if ($this.constraints.alignment==RIGHT) {if ($this.x  >= $this.initPosX + $this.width*$this.constraints.hiddenPercentage) panelHidden=true;}
						else if ($this.constraints.alignment==TOP) {if ($this.y  <= $this.initPosY - $this.height*$this.constraints.hiddenPercentage) panelHidden=true;}
						else if ($this.constraints.alignment==BOTTOM) {if ($this.y  >= $this.initPosY + $this.height*$this.constraints.hiddenPercentage) panelHidden=true;}
					
						if (panelHidden)
						{
							clearInterval($this.timer);
							$this.timer = null;

							if ($this.constraints.alignment==LEFT) $this.setLocation($this.initPosX - $this.width*$this.constraints.hiddenPercentage, $this.y);
							else if ($this.constraints.alignment==RIGHT) $this.setLocation($this.initPosX + $this.width*$this.constraints.hiddenPercentage, $this.y);
							else if ($this.constraints.alignment==TOP) $this.setLocation($this.x, $this.initPosY - $this.height*$this.constraints.hiddenPercentage);
							else if ($this.constraints.alignment==BOTTOM) $this.setLocation($this.x, $this.initPosY + $this.height*$this.constraints.hiddenPercentage);
						}
						else
						{
							if ($this.constraints.alignment==LEFT) $this.setLocation($this.x - $this.dt, $this.y);
							else if ($this.constraints.alignment==RIGHT) $this.setLocation($this.x + $this.dt, $this.y);
							else if ($this.constraints.alignment==TOP) $this.setLocation($this.x, $this.y - $this.dt);
							else if ($this.constraints.alignment==BOTTOM) $this.setLocation($this.x, $this.y + $this.dt);
							
							$this.counter++;
							if ($this.counter % 10 === 0) $this.dt = $this.dt*2;
						}
					}, 1);				
				}
			}
		}
	}
}
//POP UP PANELS



//DOCKED PANELS