#include <iostream>
#include <cstdlib>
#include <cstring>
#include <math.h>
#include <iostream>
#include <string>

///////////////////////////////////
//      External Libraries       //
///////////////////////////////////

#include "chuck_fft.h"
#include "RtAudio.h"
#include "Thread.h"
#ifdef __MACOSX_CORE__
  #include <GLUT/glut.h>
#else
  #include <GL/gl.h>
  #include <GL/glu.h>
  #include <GL/glut.h>
#endif

//////////////////////////////////
//      Declare Variables       //
//////////////////////////////////
#define FORMAT              RTAUDIO_FLOAT32
#define BUFFER_SIZE         1024
#define FFT_SIZE            ( BUFFER_SIZE * 2 )
#define SAMPLE              float
#define PIE                 3.14159265358979
#define MV_SRATE            44100
//openGL related
GLsizei width = 800;
GLsizei height = 600;
GLsizei last_width = width;
GLsizei last_height = height;
GLenum g_fillmode = GL_FILL;
GLboolean g_fullscreen = FALSE;
GLboolean g_drawempty = FALSE;
GLfloat g_linewidth = 2.0f;
GLfloat g_freq_scale = 3.0f;
//audio related
SAMPLE fft_buffer[FFT_SIZE];
GLint buffer_size = BUFFER_SIZE;
GLint fft_size = FFT_SIZE;
SAMPLE g_buffer[BUFFER_SIZE];
unsigned int channels = 1;
//points for drawing
struct point{
  float x;  float y;
};
point *p, *p2, *p3, *p4, *p5, *p6, *p7, *p8 = NULL;
//circle mode on/off
bool drawcircle = false; 
// Threads Management
GLboolean g_ready = FALSE;
Mutex g_mutex;


/////////////////////////////////
//     Function Prototypes     //
/////////////////////////////////
int rtAudioCallback( void *outputBuffer, void *inputBuffer, unsigned int nBufferFrames, 
		     double streamTime, RtAudioStreamStatus status, void *data);
void idleFunc( );
void displayFunc( );
void reshapeFunc( int width, int height );
void keyboardFunc( unsigned char, int, int );
void initialize_graphics( );
void drawFrequencyBar(float * buffer);
void draw2DCircle(float * buffer);
void initialize_glut(int argc, char *argv[]);
void initialize_audio(RtAudio *dac);

/////////////////////////////////
//           help              //
/////////////////////////////////
void help()
{
  fprintf(stderr, "---------------------------------------------------\n");
  fprintf(stderr, "MuVi (Music Visualization in C)\n");
  fprintf(stderr, "Kwan Kim\n");
  fprintf(stderr, "New York University\n");
  fprintf(stderr, "---------------------------------------------------\n");
  fprintf(stderr, "'f' - toggle full screen\n");
  fprintf(stderr, "'c' - toggle Circle Mode On/Off\n");
  fprintf(stderr, "'q' - quit\n");
  fprintf(stderr, "---------------------------------------------------\n");
  fprintf(stderr, "\n");
}


/////////////////////////////////
//       rtAudioCallback       //
/////////////////////////////////
int rtAudioCallback( void *outputBuffer, void *inputBuffer, unsigned int nBufferFrames,
            double streamTime, RtAudioStreamStatus status, void *data )
{
  SAMPLE * obuffy = (SAMPLE *)outputBuffer;
  SAMPLE * ibuffy = (SAMPLE *)inputBuffer;
  
  // Lock mutex
  g_mutex.lock();

  //Copy the input buffer to our g_buffer
  for( int i = 0; i < nBufferFrames; i++ )
  {
    g_buffer[i] = ibuffy[i];
  }
  // set flag
  g_ready = TRUE;
  // Unlock mutex
  g_mutex.unlock();
  
  return 0;
}

/////////////////////////////////
//      initialize_glut        //
/////////////////////////////////
void initialize_glut(int argc, char *argv[]) {
  // initialize GLUT
  glutInit( &argc, argv );
  // double buffer, use rgb color, enable depth buffer
  glutInitDisplayMode( GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH );
  // initialize the window size
  glutInitWindowSize( width, height );
  // set the window postion
  glutInitWindowPosition( 400, 100 );
  // create the window
  glutCreateWindow("Music Visualization" );
  // full screen
  if( g_fullscreen )
    glutFullScreen();
    // set the idle function - called when idle
  glutIdleFunc( idleFunc );
  // set the display function - called when redrawing
  glutDisplayFunc( displayFunc );
  // set the reshape function - called when client area changes
  glutReshapeFunc( reshapeFunc );
  // set the keyboard function - called on keyboard events
  glutKeyboardFunc( keyboardFunc );
  // do our own initialization
  initialize_graphics( );  
}

//////////////////////////////////
//     initialize_rtAudio       //
//////////////////////////////////
void initialize_audio(RtAudio *dac) {
  
  if ( dac->getDeviceCount() < 1 ) {
    std::cout << "\nNo audio devices found!\n";
    exit( 0 );
  }
  // Set our stream parameters for output only.
  unsigned int bufferFrames = buffer_size;
  RtAudio::StreamParameters oParams;
  oParams.deviceId = dac->getDefaultOutputDevice();
  oParams.nChannels = channels;
  oParams.firstChannel = 0;
  
  RtAudio::StreamParameters iParams;
  iParams.deviceId = dac->getDefaultInputDevice();
  iParams.nChannels = channels;
  iParams.firstChannel = 0;
  // Try to open Stream
  try {
    buffer_size = buffer_size*channels;
    dac->openStream( &oParams, &iParams, FORMAT, MV_SRATE, 
                   &bufferFrames, &rtAudioCallback );
    dac->startStream();
  }
  catch ( RtError& e ) {
    std::cout << '\n' << e.getMessage() << '\n' << std::endl;
    dac->closeStream();
  }
}

//////////////////////////////////
//        main function         //
//////////////////////////////////
int main( int argc, char *argv[] )
{
  // Initialize Glut
  initialize_glut(argc, argv);
  
  // Initialize RtAudio
  RtAudio dac;
  initialize_audio(&dac);
  
  // Initialize points for Frequency Bar  
  p  = new point[FFT_SIZE];
  p2 = new point[FFT_SIZE];
  p3 = new point[FFT_SIZE];
  p4 = new point[FFT_SIZE];
  p5 = new point[FFT_SIZE];
  p6 = new point[FFT_SIZE];
  p7 = new point[FFT_SIZE];
  p8 = new point[FFT_SIZE];
  memset(p, 0, sizeof(point)*FFT_SIZE);
  memset(p2, 0, sizeof(point)*FFT_SIZE);
  memset(p3, 0, sizeof(point)*FFT_SIZE);
  memset(p4, 0, sizeof(point)*FFT_SIZE);
  memset(p5, 0, sizeof(point)*FFT_SIZE);
  memset(p6, 0, sizeof(point)*FFT_SIZE);
  memset(p7, 0, sizeof(point)*FFT_SIZE);
  memset(p8, 0, sizeof(point)*FFT_SIZE);
  // Wait until <enter> is pressed to stop the process
  glutMainLoop();
  
  // Close Stream before exiting
  dac.closeStream();


  return 0;
}
/////////////////////////////////
//       rtAudioCallback       //
/////////////////////////////////

//-----------------------------------------------------------------------------
// Name: idleFunc( )
// Desc: callback from GLUT
//-----------------------------------------------------------------------------
void idleFunc( )
{
  // render the scene
  glutPostRedisplay( );
}

/////////////////////////////////
//      keyboardFunc()         //
/////////////////////////////////
void keyboardFunc( unsigned char key, int x, int y )
{
  //printf("key: %c\n", key);
  switch( key )
  {

    //Circle Mode
  case 'c':
    drawcircle = !drawcircle;
    break;
    
    // Fullscreen
  case 'f':
    if( !g_fullscreen )
      {
        last_width = width;
        last_height = height;
        glutFullScreen();
      }
    else
      glutReshapeWindow( last_width, last_height );
    
    g_fullscreen = !g_fullscreen;
    printf("fullscreen: %s\n", g_fullscreen ? "ON" : "OFF" );
    break;
    
  case 'q':
    exit( 0 );
    break;
  }
  glutPostRedisplay( );
}

/////////////////////////////////
//       reshapeFunc           //
/////////////////////////////////
void reshapeFunc( int w, int h )
{
  // save the new window size
  width = w; height = h;
  // map the view port to the client area
  glViewport( 0, 0, w, h );
  // set the matrix mode to project
  glMatrixMode( GL_PROJECTION );
  // load the identity matrix
  glLoadIdentity( );
  // create the viewing frustum
  gluPerspective( 45.0, (GLfloat) w / (GLfloat) h, 1.0, 1000.0 );
  // set the matrix mode to modelview
  glMatrixMode( GL_MODELVIEW );
  // load the identity matrix
  glLoadIdentity( );
  
  gluLookAt( 0.0f, 0.0f, 10.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f );
  
}

/////////////////////////////////
//     initialize_graphics     //
/////////////////////////////////
void initialize_graphics()
{
  // Black Background
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  // set the shading model to 'smooth'
  glShadeModel( GL_SMOOTH );
  // set the front faces of polygons
  glFrontFace( GL_CCW );
  // set fill mode
  glPolygonMode( GL_FRONT_AND_BACK, g_fillmode );
  // enable lighting
  glEnable( GL_LIGHTING );
  // enable lighting for front
  glLightModeli( GL_FRONT_AND_BACK, GL_TRUE );
  // material have diffuse and ambient lighting 
  glColorMaterial( GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE );
  // enable color
  glEnable( GL_COLOR_MATERIAL );
  // normalize (for scaling)
  glEnable( GL_NORMALIZE );
  // line width
  glLineWidth( g_linewidth );
  // enable light 0
  glEnable( GL_LIGHT0 );
  //help
  help();
}

/////////////////////////////////
//      drawFrequencyBar       //
/////////////////////////////////
void drawFrequencyBar(float *buffer) {
  //Initiate variables
  GLfloat xinc; //x increment
  GLfloat x=-4.3f;
  GLfloat y=0.0;
  //Calculate increment x
  xinc = fabs((2*x)/(double)(fft_size/2));
  glTranslatef(0.0f, -3.0f, 0.0f);

  /*   Draw Frequency Bars!!   */ 
  for( int i = 0; i <64; i++ )
    {
      glColor3f(1., .2, 0.4);
      //store x & y values
      p[i].x = x; //x is stored as x coordinate of the window 
      p[i].y = 30*pow(buffer[i], 0.5); //y is stored as frequency value contained in buffer[i]
      x += xinc; //update x value
      point *pt  = p; 
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt++)
	{
	  glVertex3f( pt->x, pt->y, 0.0f );	  
	}
      glEnd();
      //line width
      glLineWidth(5.0f);
    }
  
  for( int i = 0; i < 64; i++ )
    {//draw another bar using the same mechanism described above
      glColor3f(1., .4, 0.0);
      p2[i].x = x+0.6f;
      p2[i].y = 30*pow(buffer[i+64],0.5);//we need different values from buffer, which starts from i + 64.
      x += xinc;
      point * pt2 = p2;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt2++)
	{
	  glVertex3f( pt2->x, pt2->y, 0.0f );  
	}
      glEnd();
      glLineWidth(5.0f);    
    }

  for( int i = 0; i <64; i++ )
    {
      glColor3f(1., 0.8, 0.1);
      p3[i].x = x+1.2f;
      p3[i].y = 30*pow(buffer[i+128], 0.5);//different values from the buffer
      x += xinc;
      point *pt3  = p3;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt3++)
	{
	  glVertex3f( pt3->x, pt3->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.4, .5, 0.4);
      p4[i].x = x+1.8f;
      p4[i].y = 30*pow(buffer[i+192], 0.5);
      x += xinc;
      point *pt4  = p4;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt4++)
	{
	  glVertex3f( pt4->x, pt4->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.3, 1, 0.2);
      p5[i].x = x+2.4f;
      p5[i].y = 30*pow(buffer[i+256], 0.5);
      x += xinc;
      point *pt5  = p5;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt5++)
	{
	  glVertex3f( pt5->x, pt5->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.3, 0.1, 0.8);
      p6[i].x = x+3.0f;
      p6[i].y = 30*pow(buffer[i+320], 0.5);
      x += xinc;
      point *pt6  = p6;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt6++)
	{
	  glVertex3f( pt6->x, pt6->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
  for( int i = 0; i <64; i++ )
    {
      glColor3f(1, 1, 1);
      p7[i].x = x+3.6f;
      p7[i].y = 30*pow(buffer[i+384], 0.5);
      x += xinc;
      point *pt7  = p7;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt7++)
	{
	  glVertex3f( pt7->x, pt7->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
 for( int i = 0; i <64; i++ )
    {
      glColor3f(0.5, 0.3, 0.3);
      p8[i].x = x+4.2f;
      p8[i].y = 30*pow(buffer[i+448], 0.5);
      x += xinc;
      point *pt8  = p8;
      glBegin( GL_LINE_STRIP );
      for( GLint j = 0; j < 64; j++, pt8++)
	{
	  glVertex3f( pt8->x, pt8->y, 0.0f );	  
	}
      glEnd();
      glLineWidth(5.0f);
    }
}

/////////////////////////////////
//       draw2DCircle          //
/////////////////////////////////

void draw2DCircle(float *buffer) {
  //Initiate Variables
  srand((unsigned)time(NULL)); //for randomize coordiates
  GLfloat x = rand() % 10 -5.0f;
  GLfloat y = rand() % 7;
  GLfloat x2 = rand() % 10 -5.0f;
  GLfloat y2 = rand() % 5;
  GLfloat x3 = rand() % 10 -5.0f;
  GLfloat y3 = rand() % 5;
  GLfloat x4 = rand() % 10 -5.0f;
  GLfloat y4 = rand() % 5;
  GLfloat x5 = rand() % 10 -5.0f;
  GLfloat y5 = rand() % 5;
  GLfloat x6 = rand() % 10 -5.0f;
  GLfloat y6 = rand() % 5;
  GLfloat x7 = rand() % 10 -5.0f;
  GLfloat y7 = rand() % 5;
  GLfloat x8 = rand() % 10 -5.0f;
  GLfloat y8 = rand() % 5;
  
  /* Draw Circles!! */   
  glTranslatef(0.0f, -3.0f, 0.0f);
  for( int i = 0; i <64; i++ )
    {
      glColor3f(1., .2, 0.4);
      float r = 20*pow(buffer[i],0.5); //read in 64 values from the buffer
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x +sin(t)*r, y + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
    
  for( int i = 0; i < 64; i++ )
    {
      glColor3f(1., .4, 0.0);
      float r = 20*pow(buffer[i+64],0.5); //read in another 64 from the buffer
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{    
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x2 +sin(t)*r, y2 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
  
  for( int i = 0; i <64; i++ )
    {
      glColor3f(1., 0.8, 0.1);
      float r = 20*pow(buffer[i+128],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x3 +sin(t)*r, y3 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
  
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.4, .5, 0.4);
      float r = 20*pow(buffer[i+192],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x4 +sin(t)*r, y4 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
  
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.3, 1, 0.2);
      float r = 20*pow(buffer[i+256],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x5 +sin(t)*r, y5 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
 
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.3, 0.1, 0.8);
      float r = 20*pow(buffer[i+320],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x6 +sin(t)*r, y6 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
 
  for( int i = 0; i <64; i++ )
    {
      glColor3f(1, 1, 1);
      float r = 20*pow(buffer[i+384],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x7 +sin(t)*r, y7 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
 
  for( int i = 0; i <64; i++ )
    {
      glColor3f(0.5, 0.3, 0.3);
      float r = 20*pow(buffer[i+448],0.5);
      int segment = 1000;
      glBegin( GL_LINES );
      for( int n = 0; n <= segment; n++)
	{
	  float const t = 2*PIE*(float)n/(float)segment;
	  glVertex2f(x8 +sin(t)*r, y8 + cos(t)*r);
	}
      glEnd();
      glLineWidth(1.0f);
    }
}


/////////////////////////////////
//        displayFunc          //
/////////////////////////////////
void displayFunc( )
{
  // local state
  static GLfloat zrot = 0.0f, c = 0.0f;
  GLfloat x, xinc;
  
  // local variables
  SAMPLE buffer[fft_size];
  
  // wait for data
  while( !g_ready ) usleep( 1000 );
  
  // lock
  g_mutex.lock();
  
  // get the latest (possibly preview) window
  memset( buffer, 0, fft_size * sizeof(SAMPLE) );
  
  // copy currently playing audio into buffer
  memcpy( buffer, g_buffer, buffer_size * sizeof(SAMPLE) );
  
  // Hand off to audio callback thread
  g_ready = FALSE;
  
  // unlock
  g_mutex.unlock();
  
  // clear the color and depth buffers
  glClear( GL_COLOR_BUFFER_BIT);
 
  // save state
  glPushMatrix();
  {
    // take forward FFT and real values are stored in (float *)buffer
    rfft( (float *)buffer, fft_size/2, FFT_FORWARD );
    if (drawcircle){    
      draw2DCircle(buffer);
    } else {
      drawFrequencyBar(buffer);
    }
  }
  //pop matrix for the rotations
  glPopMatrix();
  // flush gl commands
  glFlush( );
  // swap the buffers
  glutSwapBuffers( );  
}

