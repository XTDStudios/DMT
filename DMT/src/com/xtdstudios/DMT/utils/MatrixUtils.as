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
	}
}