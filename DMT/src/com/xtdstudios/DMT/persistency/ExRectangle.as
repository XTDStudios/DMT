/**
 * Created by gil on 4/5/14.
 */
package com.xtdstudios.DMT.persistency
{
	import flash.geom.Rectangle;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class ExRectangle implements IExternalizable
	{
		private var m_rect  : Rectangle;

		public function ExRectangle()
		{
		}

		public function writeExternal(output:IDataOutput): void {
			output.writeFloat(m_rect.width);
			output.writeFloat(m_rect.height);
			output.writeFloat(m_rect.x);
			output.writeFloat(m_rect.y);
		}

		public function readExternal(input:IDataInput): void {
			if (!m_rect)
				m_rect = new Rectangle();

			m_rect.width = input.readFloat();
			m_rect.height = input.readFloat();
			m_rect.x = input.readFloat();
			m_rect.y = input.readFloat();
		}

		public function set rectangle(value:Rectangle):void
		{
			m_rect = value;
		}

		public function get rectangle():Rectangle
		{
			return m_rect;
		}
	}
}
