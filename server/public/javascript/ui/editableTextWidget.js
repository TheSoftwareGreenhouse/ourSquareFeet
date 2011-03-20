(function() {
  var $, EditableTextWidget, Observatory, root;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./../observatory').Observatory : this.Observatory;
  $ = typeof exports != "undefined" && exports !== null ? require("../../../../test/mockjQuery.coffee").jQuery : jQuery;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  EditableTextWidget = function(canvas, x, y, text) {
    var widget, _createTextBox, _inputBox, _observatory, _text;
    _text = {};
    _inputBox = $("input#plantName");
    _createTextBox = function(theText) {
      var newText;
      newText = canvas.text(x, y, theText.replace(/\s/g, "\n"));
      newText.dimension = newText.getBBox();
      newText.originalText = theText;
      newText.dblclick(function(event) {
        var height, left, top, width;
        newText.hide();
        left = x - 50;
        top = y - Math.floor(newText.dimension.height);
        width = 100;
        height = newText.dimension.height * 2;
        return _inputBox.css('left', left).css('top', top).css('width', width).css('height', height).val(theText).show().focus().bind("blur", function(event) {
          var newValue;
          _inputBox.hide();
          _inputBox.unbind("blur");
          newValue = _inputBox.val();
          _inputBox.val(null);
          newText.show();
          if (newValue !== newText.originalText) {
            return _observatory.publish("change", newValue);
          }
        });
      });
      return newText;
    };
    _text = _createTextBox(text);
    _observatory = new Observatory();
    _inputBox.hide();
    return widget = {
      hover: function(onMouseOver, onMouseOut) {
        return _text.hover(onMouseOver, onMouseOut);
      },
      onChange: function(callback) {
        return _observatory.subscribe("change", callback);
      },
      attr: function(attributes) {
        return _text.attr(attributes);
      },
      remove: function() {
        return _text.remove();
      }
    };
  };
  root.EditableTextWidget = EditableTextWidget;
}).call(this);
