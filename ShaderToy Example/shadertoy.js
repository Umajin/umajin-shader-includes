registerComponent('shaderToy', '', 'ShaderToy', 'Shows ShaderToy example', 'shaderToy_onInit', 'shaderToy_onResize', 'shaderToy_onResize', '', '');

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
	shaderUpdateUniformTexture("shader_toy", "iChannel0", "images/button_01_default_9.png")
	shaderUpdateUniformTexture("shader_toy", "iChannel1", "images/scrollbar_h_9.png")
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
	renderkitShapeDoMove(rk, id, 0, 0)
	
	renderkitShapeDoLine(rk, id, 0, 0)
	renderkitShapeDoLine(rk, id, width, 0)
	renderkitShapeDoLine(rk, id, width, height)
	renderkitShapeDoLine(rk, id, 0, height)
	
	renderkitShapeDoClose(rk, id)

	shaderUpdateUniformFloat2("shader_toy", "umajin_window_size", width, height)
}

function shaderToy_onMove(x, y, touchID, mod)
{
	shaderUpdateUniformFloat3("shader_toy", "umajin_cursor", x, y, 0)
}