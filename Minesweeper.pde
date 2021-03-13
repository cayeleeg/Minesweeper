import de.bezier.guido.*;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

static public int NUM_ROWS = 20;
static public int NUM_COLS = 20;
static public int NUM_MINES = 20;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++ ) {
      for(int c = 0; c < NUM_COLS; c++ ) {
        buttons[r][c] = new MSButton(r,c);
      }
    }
    mines = new ArrayList<MSButton>();
    while(mines.size() < NUM_MINES) {
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int clicked = 0;
    for(int r=0; r < NUM_ROWS; r++) {
      for(int c=0; c <NUM_COLS; c++) {
        if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == true) {
          clicked++;
        }
      }
    }
    return false;
}
public void displayLosingMessage()
{
    //your code here
    int x = 0;
    String loseMessage = "YOU LOSE";
    for(int c = 5; c < 13; c++) {
        buttons[10][c].setLabel(loseMessage.substring(x, x+1));
        x++;
    }
}
public void displayWinningMessage()
{
    //your code here
    int x = 0;
    String winMessage = "YOU WIN";
    for(int c = 5; c < 13; c++) {
        buttons[10][c].setLabel(winMessage.substring(x, x+1));
        x++;
    }
}
public boolean isValid(int r, int c)
{
    //your code here
    if(r < NUM_ROWS && c < NUM_ROWS && r >= 0 && c >= 0) {
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int b = -1; b < 2; b++) {
      for(int c=-1; c < 2; c++) {
        if((b==0 && c==0) == false) {
          if(isValid(row+b, col+c) && mines.contains(buttons[row+b][col+c])) {
            numMines++;
          }
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT) {
          flagged = !flagged;
          if(flagged == false) {
            clicked = false;
          }
        } else if(mines.contains(this)) {
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0) {
          setLabel(""+countMines(myRow,myCol));
        } else { ////
          for(int row=0;row<3;row++) {
            //Check top 
            if(isValid(myRow-1+row, myCol+1) && buttons[myRow-1+row][myCol+1].clicked == false) {
              buttons[myRow-1+row][myCol+1].mousePressed();
            }
            //Check bottom 
            if(isValid(myRow-1+row, myCol-1) && buttons[myRow-1+row][myCol-1].clicked == false) {
              buttons[myRow-1+row][myCol-1].mousePressed();
            }
          }
          //Check buttons left right
          if(isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false) {
            buttons[myRow-1][myCol].mousePressed();
          }
          if(isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
            buttons[myRow+1][myCol].mousePressed();
          }
        } ////
     } //
     
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}

