window.addEventListener("load", () => {
	const canvas = document.querySelector(".background-canvas");
	const gl = canvas.getContext("webgl");
	if (!gl) {
		console.error("WebGL not supported");
		return;
	}

	let width = (canvas.width = window.innerWidth);
	let height = (canvas.height = window.innerHeight);

	function resizeCanvas() {
		width = canvas.width = window.innerWidth;
		height = canvas.height = window.innerHeight;
		gl.viewport(0, 0, width, height);
	}
	window.addEventListener("resize", resizeCanvas);

	let mouse = { x: width / 2, y: height / 2 };
	function onMouseMove(e) {
		mouse.x = e.clientX;
		mouse.y = e.clientY;
	}
	window.addEventListener("mousemove", onMouseMove);

	const circleColors = [
		[18 / 255, 113 / 255, 1.0],
		[221 / 255, 74 / 255, 1.0],
		[100 / 255, 220 / 255, 1.0],
		[200 / 255, 50 / 255, 50 / 255],
		[180 / 255, 180 / 255, 50 / 255],
		[140 / 255, 100 / 255, 1.0],
	];

	let circles = [];
	function initCircles() {
		circles = [];
		const baseRadius = (width + height) * 0.2;
		for (let i = 0; i < 5; i++) {
			const radius = baseRadius;
			const x = Math.random() * width;
			const y = Math.random() * height;
			const speedMultiplier = Math.random() * 0.3 + 0.3;
			const vx = (Math.random() - 0.5) * speedMultiplier;
			const vy = (Math.random() - 0.5) * speedMultiplier;
			circles.push({
				x,
				y,
				radius,
				color: circleColors[i],
				vx,
				vy,
				interactive: false,
			});
		}

		// interactive circle
		const interactiveRadius = (width + height) * 0.1;
		circles.push({
			x: width / 2,
			y: height / 2,
			radius: interactiveRadius,
			color: circleColors[5],
			vx: 0,
			vy: 0,
			interactive: true,
		});
	}

	initCircles();

	const vertexSrc = `
    attribute vec2 a_position;
    varying vec2 v_uv;
    void main(void) {
      v_uv = a_position * 0.5 + 0.5; 
      v_uv.y = 1.0 - v_uv.y; 
      gl_Position = vec4(a_position, 0.0, 1.0);
    }
`;

	const fragmentSrc = `
precision mediump float;
varying vec2 v_uv;

uniform vec2 u_resolution;
uniform bool u_darkMode;
uniform int u_circleCount;
uniform vec3 u_circlesColor[6];
uniform vec3 u_circlesPosRad[6];
uniform vec2 u_mouse;

void main(void) {
    vec2 st = v_uv * u_resolution;

    vec3 topColor = vec3(108.0/255.0, 0.0, 162.0/255.0);
    vec3 bottomColor = vec3(0.0, 17.0/255.0, 82.0/255.0);
    vec3 bgColor = mix(topColor, bottomColor, st.y / u_resolution.y);

    float fieldSum = 0.0;
    vec3 weightedColorSum = vec3(0.0);
    
    for (int i = 0; i < 6; i++) {
        if (i >= u_circleCount) { break; }
        vec3 posRad = u_circlesPosRad[i];
        vec2 cPos = vec2(posRad.r, posRad.g);
        float radius = posRad.b;
        float dist = length(st - cPos);
        float sigma = radius * 0.5;
        float val = exp(- (dist * dist) / (2.0 * sigma * sigma));
        fieldSum += val;
        weightedColorSum += u_circlesColor[i] * val;
    }

    vec3 finalCirclesColor = vec3(0.0);
    if (fieldSum > 0.0) {
        finalCirclesColor = weightedColorSum / fieldSum;
    }

    float intensity = pow(fieldSum, 1.4);
    vec3 finalColor = mix(bgColor, finalCirclesColor, clamp(intensity, 0.0, 1.0));
    gl_FragColor = vec4(finalColor, 1.0);
}
`;

	function createShader(type, source) {
		const shader = gl.createShader(type);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);
		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
			console.error("Shader compile error:", gl.getShaderInfoLog(shader));
			gl.deleteShader(shader);
			return null;
		}
		return shader;
	}

	const vertShader = createShader(gl.VERTEX_SHADER, vertexSrc);
	const fragShader = createShader(gl.FRAGMENT_SHADER, fragmentSrc);

	const program = gl.createProgram();
	gl.attachShader(program, vertShader);
	gl.attachShader(program, fragShader);
	gl.linkProgram(program);
	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
		console.error("Program link error:", gl.getProgramInfoLog(program));
	}

	gl.useProgram(program);

	const quadBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, quadBuffer);
	const vertices = new Float32Array([
		-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1,
	]);
	gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

	const a_position = gl.getAttribLocation(program, "a_position");
	gl.enableVertexAttribArray(a_position);
	gl.vertexAttribPointer(a_position, 2, gl.FLOAT, false, 0, 0);

	const u_resolution = gl.getUniformLocation(program, "u_resolution");
	const u_darkMode = gl.getUniformLocation(program, "u_darkMode");
	const u_circleCount = gl.getUniformLocation(program, "u_circleCount");
	const u_circlesColor = gl.getUniformLocation(program, "u_circlesColor");
	const u_circlesPosRad = gl.getUniformLocation(program, "u_circlesPosRad");
	const u_mouse = gl.getUniformLocation(program, "u_mouse");

	gl.uniform2f(u_resolution, width, height);

	function updateCircles() {
		for (let i = 0; i < circles.length; i++) {
			const c = circles[i];
			if (!c.interactive) {
				c.x += c.vx;
				c.y += c.vy;
				if (c.x - c.radius > width) c.x = -c.radius;
				if (c.x + c.radius < 0) c.x = width + c.radius;
				if (c.y - c.radius > height) c.y = -c.radius;
				if (c.y + c.radius < 0) c.y = height + c.radius;
			} else {
				c.x += (mouse.x - c.x) * 0.1;
				c.y += (mouse.y - c.y) * 0.1;
			}
		}
	}

	function render() {
		updateCircles();

		gl.viewport(0, 0, width, height);
		gl.clearColor(0, 0, 0, 1);
		gl.clear(gl.COLOR_BUFFER_BIT);

		gl.useProgram(program);

		gl.uniform1i(u_circleCount, circles.length);
		gl.uniform2f(u_resolution, width, height);
		gl.uniform2f(u_mouse, mouse.x, mouse.y);

		let colorsArr = [];
		let posRadArr = [];
		for (let i = 0; i < 6; i++) {
			if (i < circles.length) {
				const c = circles[i];
				colorsArr.push(c.color[0], c.color[1], c.color[2]);
				posRadArr.push(c.x, c.y, c.radius);
			} else {
				colorsArr.push(0, 0, 0);
				posRadArr.push(0, 0, 0);
			}
		}

		gl.uniform3fv(u_circlesColor, new Float32Array(colorsArr));
		gl.uniform3fv(u_circlesPosRad, new Float32Array(posRadArr));

		gl.drawArrays(gl.TRIANGLES, 0, 6);
		requestAnimationFrame(render);
	}

	render();
});
