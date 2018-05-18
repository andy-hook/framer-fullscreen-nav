# Configure viewport
Framer.Device.customize
	deviceType: "fullscreen"
	screenWidth: 1700
	screenHeight: 956
	deviceImageWidth: 1700
	deviceImageHeight: 956
	devicePixelRatio: 1

navItems = [inferno, brandwatch, vizia, cymbiosis, monster, sketchbook]

currentActive = []
allowShow = false;
navOpen = false;

# Topbar
# ------------------------------------------------------------------
jobTitle.states =
	dark:
		color: '#7F8188'
		animationOptions:
			time: 0
	light:
		color: '7F8188'
		animationOptions:
			time: 0

jobTitle.stateSwitch('dark')

changeJobTitle = () ->
	Utils.delay .4, ->
		if !allowShow
			jobTitle.animate('dark')
			

logo.states =
	dark:
		color: '#F6F6F7'
		animationOptions:
			time: 0
	light:
		color: '2C2C37'
		animationOptions:
			time: 0

logo.stateSwitch('dark')

changeLogo = () ->
	Utils.delay .39, ->
		if !allowShow
			logo.animate('dark')

border.states =
	dark:
		color: '#3E3E47'
		animationOptions:
			time: 0
	light:
		color: 'E8E8EA'
		animationOptions:
			time: 0
			delay: 0

border.stateSwitch('dark')

changeBorder = () ->
	Utils.delay .27, ->
		if !allowShow
			border.animate('dark')



# Main navigation interactions
# ------------------------------------------------------------------
for item, index in navItems

# 	Item text
	itemText = item.selectChild('text')
	itemText.index = 100
	itemText.animationOptions =
		curve: Spring(damping: .8, mass: .9, velocity: .1)
		
	itemText.states.first =
		x: Align.right(-25)
		opacity: .2
		animationOptions:
			time: 1

	itemText.states.hovered =
		x: Align.right(-10)
		opacity: 1
		animationOptions:
			time: .5

# 	Containing frame
	item.clip = true
	item.width = itemText.width + 300
	item.x = Align.right(25)
	
# 	Apply positioning state to text after item has been sized otherwise it renders incorrectly on first load
	itemText.stateSwitch('first')
	
# 	Moving slice
	slice = new Layer
		backgroundColor: 'EEEFF2'
		parent: item
		name: 'movingSlice'
		height: item.height * 10
		width: item.width - 60
		y: Align.center
		index: 0
		originX: 1
		animationOptions: 
			time: .5
	
	slice.states.first = 
		x: -(item.width * 1)
		rotation: -50
		
	slice.states.hovered = 
		x: 0
		rotation: 0
		animationOptions:
			time: .8
			curve: Spring(damping: .9, mass: 1)
			
	
	slice.states.out = 
		x: (item.width + 40)
		rotation: -15
		animationOptions:
			time: 1
			curve: Spring(damping: .8, mass: .9, velocity: .1)
	
	slice.stateSwitch('first')
	
	item.on Events.MouseOver, (event, layer) ->
		itemSlice = this.selectChild('movingSlice')
		itemText = this.selectChild('text')
		
		itemSlice.ignoreEvents = true
		itemText.ignoreEvents = true
		
		itemSlice.off Events.AnimationEnd
		
		if itemSlice.states.current.name is 'out'
			itemSlice.stateSwitch('first')
			itemSlice.animate('hovered')
		else
			itemSlice.animate('hovered')
			
		
		itemText.animate('hovered')
	
	item.on Events.MouseOut, (event, layer) ->
		itemSlice = this.selectChild('movingSlice')
		
		itemSlice.on Events.AnimationEnd, -> 
			itemSlice.stateSwitch('first')
		
		itemSlice.animate('out')
		itemText.animate('first')
	
	
# Social interactions	
for socialButton, index in [twitter, dribbble, instagram, github, linkedin]
	socialText = socialButton.selectChild('text')
	socialText.animationOptions =
		time: .4
	
	socialText.states.initial =
		opacity: .4
		
	socialText.states.hovered =
		opacity: 1
		
	socialText.stateSwitch('initial')
	
	socialButton.height = socialText.height + 20
	socialButton.clip = true
	
		
	# 	Moving underline
	underline = new Layer
		backgroundColor: 'E8E8EA'
		parent: socialButton
		name: 'underline'
		height: 2
		width: socialButton.width
		y: Align.bottom
		x: Align.left
		index: 0
		originX: 1
		animationOptions: 
			time: .4
			curve: Spring(mass: .9, velocity: 1, damping: .9)
	
	underline.states.left =
			x: Align.left(-socialButton.width)
			
	underline.states.right =
			x: Align.left(socialButton.width)
			
	underline.states.hovered =
			x: Align.left
	
	underline.stateSwitch('left')
	
# 	Don't bubble events
	underline.ignoreEvents = true
	socialText.ignoreEvents = true
	
	socialButton.on Events.MouseOver, (e, layer) ->
		thisUnderline = this.selectChild('underline')
		thisText = this.selectChild('text')
		
		thisText.animate('hovered')
		
		thisUnderline.stateSwitch('left')
		thisUnderline.animate('hovered')

	socialButton.on Events.MouseOut, (e, layer) ->
		thisUnderline = this.selectChild('underline')
		
		thisText = this.selectChild('text')
		
		thisText.animate('initial')
		
		thisUnderline.animate('right')


# Nav items open / close
# ------------------------------------------------------------------

reversedItems = navItems.reverse()
navItemDelayIn = .04
navItemStartIn = .0

navItemDelayOut = .0
for item, index in reversedItems
	
	item.states.initial = 
		opacity: 0
		y: item.y - (index + 7 * 80)
		animationOptions:
			time: .2
			curve: Bezier(.05,1.05,.58,1.01)
	
	item.states.visible =
		opacity: 1
		y: item.y
		animationOptions:
			time: .9
			curve: Bezier(.05,1.05,.58,1.01)
	
	item.states.hidden = 
		opacity: 0
		y: item.y - 100
		animationOptions:
			time: .3
			curve: Bezier(.05,1.05,.58,1.01)
	
	item.stateSwitch('initial')

# Setup navicon
navicon.states.closed =
	opacity: .3
	
navicon.states.open =
	opacity: 1

navicon.stateSwitch('closed')

# Show
showNavItem = (item, i) ->

	Utils.delay i * navItemDelayIn + navItemStartIn, ->
		if allowShow
			item.stateSwitch('initial')
			item.animate('visible')
			
# 			Add to active array after visible
			currentActive.push(item)

# Hide
hideNavItem = (item, i) ->
	
	Utils.delay i * navItemDelayOut, ->
			item.animate('hidden')
			
# 			Remove item from array after being hidden
			indexOf = currentActive.indexOf(item)
			currentActive.splice(indexOf, 1)


	
# Main title open / close
# ------------------------------------------------------------------
mainTitle.states =
	hidden:
		opacity: 0
		y: mainTitle.y - 100
		animationOptions:
			time: .1
	visible:
		opacity: 1
		y: mainTitle.y
		animationOptions:
			time: .5
			curve: Bezier(.06,.31,.32,1)

mainTitle.stateSwitch('hidden')

showMainTitle = () ->
	Utils.delay .15, ->
		if allowShow
			mainTitle.animate('visible')


# Aux details open / close
# ------------------------------------------------------------------
auxDetails.states =
	hidden:
		opacity: 0
		y: auxDetails.y - 75
		animationOptions:
			time: .1
	visible:
		opacity: 1
		y: auxDetails.y
		animationOptions:
			time: .5

auxDetails.stateSwitch('hidden')

showAux = () ->
	Utils.delay .2, ->
		if allowShow
			auxDetails.animate('visible')


	
# Nav items open / close
# ------------------------------------------------------------------

drawer.states =
	closed:
		y: -drawer.height
		animationOptions:
			time: .5
# 			curve: Bezier(.09,.68,.27,.9)
	open:
		y: 0
		animationOptions:
			time: .5
# 			curve: Bezier(.09,.68,.27,.9)

drawer.stateSwitch('closed')

drawerAngle = new Layer
	width: drawer.width
	height: 200
	y: Align.bottom

drawer.addChild(drawerAngle)
	
drawerAngleInner = new Layer
drawerAngle.addChild(drawerAngleInner)

drawerAngleInner.props =
	rotation: 0
	width: drawerAngle.width * 2
	height: drawerAngle.height * 3.5
	y: Align.bottom
	x: Align.center
	backgroundColor: '#FBFCFC'

			
rotateAngleDown = () ->
	drawerAngle.originX = 1
	drawerAngle.originY = 1
	
	drawerAngle.animate
		rotation: -20
		options:
			time: .2

	Utils.delay .05, ->
		if allowShow
			drawerAngle.animate
				rotation: 0
				options:
					time: .45
			

rotateAngleUp = () ->
	drawerAngle.originX = 0
	drawerAngle.originY = 1
	
	drawerAngle.animate
		rotation: 20
		options:
			time: .2

	Utils.delay .05, ->
		if !allowShow
			drawerAngle.animate
				rotation: 0
				options:
					time: .45


	
	
# Nav toggle
# ------------------------------------------------------------------
toggleNav = () ->
	if !navOpen
		allowShow = true
		navOpen = true
		
		drawer.animate('open')
		showMainTitle()
		showAux()
		logo.animate('light')
		jobTitle.animate('light')
		border.animate('light')
		
		rotateAngleDown()
# 		drawerAngle.animate('rotated')
		
		for item, index in navItems
			showNavItem(item, index)
	else 
		allowShow = false
		navOpen = false
		
		drawer.animate('closed')
		
		changeLogo()
		changeJobTitle()
		changeBorder()
		
		rotateAngleUp()
# 		drawerAngle.animate('initial')
		
		mainTitle.animate('hidden')
		auxDetails.animate('hidden')
		
		for item, index in currentActive
			hideNavItem(item, index)

# Menu open / close
navicon.on Events.MouseDown, (e, layer) ->
	toggleNav()
	