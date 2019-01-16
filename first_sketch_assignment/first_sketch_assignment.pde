import java.awt.Point;

protected static final int[] BG_COLORS = {255, 255, 255}; // Used as the background for the canvas, as well as the 'erase' color
public static final int CURSOR_SIZE = 20; // Used as both X and Y size for the cursor
protected Point lastPos; // Last mouse cursor position in X and Y
protected int lastState; // Last mouse button pressed
protected int[] colors; // Current cursor color from last draw routine

void setup()
{
  // Set background colors, canvas size, and initial cursor states
  background(BG_COLORS[0], BG_COLORS[1], BG_COLORS[2]);
  size(720, 480);
  lastPos = new Point(0,0);
  lastState = Integer.MIN_VALUE;
  colors = new int[3];
}

void draw()
{
  // If no mouse button is pressed, or if the mouse cursor position has not changed since
  // the last draw routine, exit after a 10ms delay. This saves memory by not repeatedly re-drawing
  // parts of the canvas that are hidden by other ink already.
  if(!mousePressed || (mouseX == lastPos.x && mouseY == lastPos.y && mouseButton == lastState)){
    try{
      Thread.sleep(10);
    }catch(InterruptedException ignored) {}
    return;
  }
    
  switch(mouseButton){
    case LEFT:
      // Set all indices to 0 (black) for left-click drawing
      for(int i = 0; i < colors.length; i++) colors[i] = 0;
    break;

    case RIGHT:
      // Set color to cyan-blue for right-click drawing
      colors[0] = 0;
      colors[1] = 192;
      colors[2] = 255;
    break;
    
    default:
      // For all other buttons (middle, side, etc), "erase" by setting color to match the background
      colors = BG_COLORS;
    break;
  }
  
  // Draw cursor to canvas with set color
  fill(colors[0], colors[1], colors[2]);
  noStroke();
  ellipse(mouseX, mouseY, CURSOR_SIZE, CURSOR_SIZE);
  
  // Cache mouse state and position
  lastPos.x = mouseX;
  lastPos.y = mouseY;
  lastState = mouseButton;
}
