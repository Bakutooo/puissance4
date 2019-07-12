import 'package:stagexl/stagexl.dart';

class Game {
  ResourceManager _rm;
  Stage _stage;
  Sprite _gridSprite;
  var grid = 
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
    ];

  double _startWidth;
  double _endHeight;
  bool _currentPlayer = true;

  Game(Stage stage) {
    _rm = ResourceManager();
    _stage = stage;
  }

  init() async {
    await _loadRessource();
  }

  start(){
    _displayGrid();
    _displayArrow();
  }

  _displayGrid(){
    var gridData = _rm.getBitmapData("grid");
    Sprite grid = Sprite();
    grid.addChild(Bitmap(gridData));

    _startWidth = (1280 - gridData.width)/2;
    _endHeight = 150 + gridData.height;
    grid.x = _startWidth;
    grid.y = 150;
    _stage.addChild(grid);
    _gridSprite = grid;
  }

  _displayArrow(){
    for(int i = 0; i < 7; i++){  
      var arrowData = _rm.getBitmapData("arrow");
      Sprite arrow = Sprite();
      arrow.addChild(Bitmap(arrowData));

      arrow.x = _startWidth + 5 + ((arrowData.width + 6) * i);
      arrow.y = 50;
      _stage.addChild(arrow);

      arrow.onMouseClick.listen((MouseEvent e){
        if(!_placeToken(arrow.x, i)) _stage.removeChild(arrow);
      });
    }
  }

  bool _placeToken(double posX, int column){
    var tokenData = _rm.getBitmapData(_currentPlayer ? "red" : "yellow");
    var token = Sprite();
    token.addChild(Bitmap(tokenData));
    token.x = posX;
    
    var currentY = _getCurrentY(column);
    token.y = 50;
    
    grid[column][currentY] = 1; 

    _stage.addChild(token);
    _stage.swapChildren(_gridSprite, token);
    
    var y = _endHeight - tokenData.width - 5;
    y -= (tokenData.width + 5) * currentY;

    Tween fall;
    fall = _stage.juggler.addTween(token, 2, Transition.easeOutBounce);
    fall.animate.y.to(y);

    _currentPlayer = !_currentPlayer;
    return currentY != 5;
  }

  _loadRessource() async {
    _rm.addBitmapData("grid", "images/grille.png");
    _rm.addBitmapData("red", "images/red.png");
    _rm.addBitmapData("yellow", "images/yellow.png");
    _rm.addBitmapData("arrow", "images/arrow.png");
    await _rm.load();
  }

  _getCurrentY(int column){
    for(int i = 0; i < 6; i++){
      if(grid[column][i] == 0) return i;
    }

    return 0;
  }
}