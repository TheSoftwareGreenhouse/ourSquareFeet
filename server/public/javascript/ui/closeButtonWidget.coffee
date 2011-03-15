#Rectangle = if exports? then require('./rectangle').Rectangle else this.Rectangle

root = exports ? this

CloseButtonWidget = (layoutEngine, top, right) ->
  _columnWidth = layoutEngine.columnWidth
  _rowHeight = layoutEngine.rowHeight
  FACTOR = 0.05
  CROSS_FACTOR = 0.25
  _border = Math.floor(FACTOR * _columnWidth)
  _width = Math.floor(0.15 * _columnWidth)
  _height = Math.floor(0.15 * _rowHeight)
  _left = right - _width - _border
  _top = top + _border
  {
    top:    _top
    left:   _left
    width:  _width
    height: _height
    cross: {
      left:   _left + Math.floor(CROSS_FACTOR * _width)
      top:    _top + Math.floor(CROSS_FACTOR * _height)
      width:  Math.floor((1-(1.5*CROSS_FACTOR)) * _width)
      height: Math.floor((1-(1.5*CROSS_FACTOR)) * _height)
    }
  }

root.CloseButtonWidget = CloseButtonWidget