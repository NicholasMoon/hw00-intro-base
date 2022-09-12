import {mat4, vec3, vec4} from 'gl-matrix';
import Drawable from './Drawable';
import Camera from '../../Camera';
import {gl} from '../../globals';
import ShaderProgram from './ShaderProgram';

// In this file, `gl` is accessible because it is imported above
class OpenGLRenderer {
  constructor(public canvas: HTMLCanvasElement) {
  }

  setClearColor(r: number, g: number, b: number, a: number) {
    gl.clearColor(r, g, b, a);
  }

  setSize(width: number, height: number) {
    this.canvas.width = width;
    this.canvas.height = height;
  }

  clear() {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }

  render(camera: Camera, prog: ShaderProgram, drawables: Array<Drawable>, ucolor: vec3, myTime: number) {
    let model = mat4.create();
    let viewProj = mat4.create();
    let color = vec4.fromValues(ucolor[0], ucolor[1], ucolor[2], 1);

    mat4.identity(model);
    mat4.multiply(viewProj, camera.projectionMatrix, camera.viewMatrix);
    prog.setModelMatrix(model);
    prog.setViewProjMatrix(viewProj);
    prog.setGeometryColor(color);
	prog.setTime(myTime);

	for (let z = 0; z < 100; z += 1) {
		for (let x = 0; x < 100; x += 1) {
			let model = mat4.create();
			mat4.fromScaling(model, vec3.fromValues(0.1,0.1,0.1));
			mat4.translate(model, model, vec3.fromValues(x, 0,z));
			prog.setModelMatrix(model);
			
			prog.draw(drawables[x + z * 10]);
			
		}
	}
  }
};

export default OpenGLRenderer;
