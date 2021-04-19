registerComponent(
	'shaderToy',
	'',
	'ShaderToy',
	'Shows ShaderToy example',
	'shaderToy_onInit',
	'shaderToy_onResize',
	'shaderToy_onRefresh',
	'color:Back Color:0xdce3d3ff,\
color:Ring Color:0x75B0BBFF,\
color:Ball Color:0x80C4EDFF,\
real:Ring Thickness:0.1:0.01:0.15',
	'');

function shaderToy_onInit(width, height)
{
	var rk = createComponent(self, "renderkit", 0, 0, 100, 100)
	bindEvent(rk, 'on_tick', 'shaderToy_onTick')
	bindEvent(rk, 'on_move', 'shaderToy_onMove')
	renderkitCameraUpdateEye(rk, 4,4,4)

	var id = renderkitShapeCreate(rk, "")
	setData(rk, "shape_id", id)
	renderkitShapeFilled(rk, id, true)
	renderkitShapeUpdateEffect(rk, id, "shader_toy")

	// Initial call of resize
	var width = getProperty(rk, "width")
	var height = getProperty(rk, "height")
	shaderToy_onResize(width, height)
}

function shaderToy_onTick()
{
	shaderUpdateUniformFloat("shader_toy", "umajin_time", getGlobal('uptime') / 1000.0)
}

function shaderToy_onResize(width, height)
{
	var rk = getComponentChild(self, 0)
	var id = getData(rk, "shape_id")

	renderkitShapeClear(rk, id)
	renderkitShapeStrokeWidth(rk, id, 0)
	renderkitShapeDoMove(rk, id, 0, 0)
	
	renderkitShapeDoLine(rk, id, 0, 0)
	renderkitShapeDoLine(rk, id, width, 0)
	renderkitShapeDoLine(rk, id, width, height)
	renderkitShapeDoLine(rk, id, 0, height)
	
	renderkitShapeDoClose(rk, id)

	shaderUpdateUniformFloat2("shader_toy", "umajin_window_size", width, height)
}

function shaderToy_onRefresh()
{
	
	var backgroundColor = getData(self, "Back Color")
	var r = parseInt(backgroundColor.slice(2, 4), 16) / 255.0
	var g = parseInt(backgroundColor.slice(4, 6), 16) / 255.0
	var b = parseInt(backgroundColor.slice(6, 8), 16) / 255.0
	var a = parseInt(backgroundColor.slice(8, 10), 16) / 255.0
	shaderUpdateUniformFloat3("shader_toy", "background_color", r, g, b)

	var ringColor = getData(self, "Ring Color")
	var r = parseInt(ringColor.slice(2, 4), 16) / 255.0
	var g = parseInt(ringColor.slice(4, 6), 16) / 255.0
	var b = parseInt(ringColor.slice(6, 8), 16) / 255.0
	var a = parseInt(ringColor.slice(8, 10), 16) / 255.0
	shaderUpdateUniformFloat3("shader_toy", "ring_color", r, g, b)

	var ballColor = getData(self, "Ball Color")
	var r = parseInt(ballColor.slice(2, 4), 16) / 255.0
	var g = parseInt(ballColor.slice(4, 6), 16) / 255.0
	var b = parseInt(ballColor.slice(6, 8), 16) / 255.0
	var a = parseInt(ballColor.slice(8, 10), 16) / 255.0
	shaderUpdateUniformFloat3("shader_toy", "ball_color", r, g, b)

	var ringThickness = getData(self, "Ring Thickness")
	shaderUpdateUniformFloat("shader_toy", "ring_thickness", ringThickness)
}

function shaderToy_onMove(x, y, touchID, mod)
{
	shaderUpdateUniformFloat3("shader_toy", "umajin_cursor", x, y, 0)
}