package com.xtdstudios.DMT.utils
{
	import flash.geom.Matrix;

	public class MatrixUtils
	{
		public static function matrixAsStr(mat:Matrix, accuracy:int=3):String {
			if (!mat)
				return ""
			else
				return 	mat.a.toFixed(accuracy) + "_" +
						mat.b.toFixed(accuracy) + "_" +
						mat.c.toFixed(accuracy) + "_" +
						mat.d.toFixed(accuracy);
		}

		public static function matrixAsObj(mat:Matrix):Object {
			return {
				a: Math.round( mat.a*1000 )/1000,
				b: Math.round( mat.b*1000 )/1000,
				c: Math.round( mat.c*1000 )/1000,
				d: Math.round( mat.d*1000 )/1000,
				tx: Math.round( mat.tx*1000 )/1000,
				ty: Math.round( mat.ty*1000 )/1000
			};
		}
	}
}