/**
 * Rectangle Packer v1.0
 * Copyright 2012 Ville Koskela. All rights reserved.
 *
 * Blog: http://villekoskela.org
 * Twitter: @villekoskelaorg
 *
 * You may redistribute, use and/or modify this class freely
 * but this copyright statement must not be removed.
 *
 * The package structure must remain unchanged.
 * 
 * Update by XTD Studios to support padding.
 *
 */
package org.villekoskela.utils
{
    import flash.geom.Rectangle;

    /**
     * Class used to pack rectangles within containers rectangle with close to optimal solution.
     * To keep the implementation simple no instance pooling or any other advanced techniques
     * are used.
     */
    public class RectanglePacker
    {
        public static const VERSION:String = "1.0";
        private var mWidth:int = 0;
        private var mHeight:int = 0;

        private var mInsertedRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
        private var mFreeAreas:Vector.<Rectangle> = new Vector.<Rectangle>();

        public function get rectangleCount():int { return mInsertedRectangles.length; }

        /**
         * Constructs new rectangle packer
         * @param width the width of the main rectangle
         * @param height the height of the main rectangle
         */
        public function RectanglePacker(width:int, height:int)
        {
            mWidth = width;
            mHeight = height;
            mFreeAreas.push(new Rectangle(0, 0, mWidth, mHeight));
        }

        /**
         * Gets the position of the rectangle in given index in the main rectangle
         * @param index the index of the rectangle
         * @param rectangle an instance where to set the rectangle's values
         * @return
         */
        public function getRectangle(index:int, rectangle:Rectangle):Rectangle
        {
            if (rectangle)
            {
                rectangle.copyFrom(mInsertedRectangles[index]);
                return rectangle;
            }

            return mInsertedRectangles[index].clone();
        }

        /**
         * Tries to insert new rectangle into the packer
         * @param rectangle
         * @return true if inserted successfully
         */
        public function insertRectangle(rectangle:Rectangle):Boolean
        {
            var index:int = getFreeAreaIndex(rectangle);
            if (index < 0)
            {
                return false;
            }

            var freeArea:Rectangle = mFreeAreas[index];
            //var target:Rectangle = new Rectangle(freeArea.left, freeArea.top, rectangle.width, rectangle.height);
			rectangle.x = freeArea.left;
			rectangle.y = freeArea.top;

            // Get the new free areas, these are parts of the old ones intersected by the target
            var newFreeAreas:Vector.<Rectangle> = generateNewSubAreas(rectangle, mFreeAreas);
            filterSubAreas(newFreeAreas, mFreeAreas, true);

            for (var i:int = newFreeAreas.length - 1; i >= 0; i--)
            {
                mFreeAreas.push(newFreeAreas[i]);
            }

            mInsertedRectangles.push(rectangle);
            return true;
        }

        /**
         * Removes rectangles from the filteredAreas that are sub rectangles of any rectangle in areas.
         * @param filteredAreas rectangles to be filtered
         * @param areas rectangles against which the filtering is performed
         * @param removeEqual if true rectangles that are equal to rectangles is areas are also removed
         */
        private function filterSubAreas(filteredAreas:Vector.<Rectangle>, areas:Vector.<Rectangle>, removeEqual:Boolean):void
        {
            for (var i:int = filteredAreas.length - 1; i >= 0; i--)
            {
                var filtered:Rectangle = filteredAreas[i];
                for (var j:int = areas.length - 1; j >= 0; j--)
                {
                    var area:Rectangle = areas[j];
                    if (area.x <= filtered.x && area.y <= filtered.y &&
                        area.x + area.width >= filtered.x + filtered.width &&
                        area.y + area.height >= filtered.y + filtered.height &&
                        (removeEqual || area.width > filtered.width || area.height > filtered.height))
                    {
                        filteredAreas.splice(i, 1);
                        break;
                    }
                }
            }
        }

        /**
         * Checks what areas the given rectangle intersects, removes those areas and
         * returns the list of new areas those areas are divived into
         * @param target the new rectangle that is dividing the areas
         * @param areas the areas to be divided
         * @return list of new areas
         */
        private function generateNewSubAreas(target:Rectangle, areas:Vector.<Rectangle>):Vector.<Rectangle>
        {
            var results:Vector.<Rectangle> = new Vector.<Rectangle>();
            for (var i:int = areas.length - 1; i >= 0; i--)
            {
                var area:Rectangle = areas[i];
                if (!(target.x >= area.x + area.width || target.x + target.width <= area.x ||
                      target.y >= area.y + area.height || target.y + target.height <= area.y))
                {
                    generateDividedAreas(target, area, results);
                    areas.splice(i, 1);
                }
            }

            filterSubAreas(results, results, false);
            return results;
        }

        /**
         * Divides the area into new sub areas around the divider.
         * @param divider rectangle that intersects the area
         * @param area rectangle to be divided into sub areas around the divider
         * @param results vector for the new sub areas around the divider
         */
        private function generateDividedAreas(divider:Rectangle, area:Rectangle, results:Vector.<Rectangle>):void
        {
            if (divider.right < area.right)
            {
                results.push(new Rectangle(divider.right, area.y, area.right - divider.right, area.height));
            }

            if (divider.x > area.x)
            {
                results.push(new Rectangle(area.x, area.y, divider.x - area.x, area.height));
            }

            if (divider.bottom < area.bottom)
            {
                results.push(new Rectangle(area.x, divider.bottom, area.width, area.bottom - divider.bottom));
            }

            if (divider.y > area.y)
            {
                results.push(new Rectangle(area.x, area.y, area.width, divider.y - area.y));
            }
        }

        /**
         * Gets the index of the best free area for the given rectangle
         * @param rectangle
         * @return index of the best free area or -1 if no suitable free area available
         */
        private function getFreeAreaIndex(rectangle:Rectangle):int
        {
            var best:Rectangle = new Rectangle(mWidth + 1, 0, 0, 0);
            var index:int = -1;

            for (var i:int = mFreeAreas.length - 1; i >= 0; i--)
            {
                var free:Rectangle = mFreeAreas[i];
                if (rectangle.width <= free.width && rectangle.height <= free.height)
                {
//					if (i % free.y) {
	                    if (free.x < best.x || (free.x == best.x && free.y < best.y))
	                    {
	                        index = i;
	                        best = free;
	                    }
//					} else {
//						if (free.y < best.y || (free.x < best.x && free.y == best.y))
//						{
//							index = i;
//							best = free;
//						}
//					}
                }
            }

            return index;
        }
    }
}
