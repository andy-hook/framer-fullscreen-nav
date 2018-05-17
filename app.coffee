# Configure viewport
Framer.Device.customize
	deviceType: "fullscreen"
	screenWidth: 1700
	screenHeight: 956
	deviceImageWidth: 1700
	deviceImageHeight: 956
	devicePixelRatio: 1

# Main navigation interactions	
for item, index in [inferno, brandwatch, vizia, cymbiosis, monster, sketchbook]
	
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

		
		