#include <nanogui/opengl.h>
#include <nanogui/glutil.h>
#include <nanogui/screen.h>
#include <nanogui/window.h>
#include <nanogui/layout.h>
#include <nanogui/label.h>
#include <nanogui/checkbox.h>
#include <nanogui/button.h>
#include <nanogui/toolbutton.h>
#include <nanogui/popupbutton.h>
#include <nanogui/combobox.h>
#include <nanogui/progressbar.h>
#include <nanogui/entypo.h>
#include <nanogui/messagedialog.h>
#include <nanogui/textbox.h>
#include <nanogui/slider.h>
#include <nanogui/imagepanel.h>
#include <nanogui/imageview.h>
#include <nanogui/vscrollpanel.h>
#include <nanogui/colorwheel.h>
#include <nanogui/colorpicker.h>
#include <nanogui/graph.h>
#include <nanogui/tabwidget.h>
#include <iostream>
#include <string>
#include <emscripten.h>
#include <chrono>
#include <random>

// Includes for the GLTexture class.
#include <cstdint>
#include <memory>
#include <utility>

#include "Box2D/Box2D.h"


#if defined(__GNUC__)
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
#endif
#if defined(_WIN32)
#pragma warning(push)
#pragma warning(disable: 4457 4456 4005 4312)
#endif

//#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>

#if defined(_WIN32)
#pragma warning(pop)
#endif
#if defined(_WIN32)
#if defined(APIENTRY)
#undef APIENTRY
#endif
#include <windows.h>
#endif

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::vector;
using std::pair;
using std::to_string;

class GLTexture {
public:
    using handleType = std::unique_ptr<uint8_t[], void(*)(void*) >;
    GLTexture() = default;

    GLTexture(const std::string& textureName)
    : mTextureName(textureName), mTextureId(0) {
    }

    GLTexture(const std::string& textureName, GLint textureId)
    : mTextureName(textureName), mTextureId(textureId) {
    }

    GLTexture(const GLTexture& other) = delete;

    GLTexture(GLTexture&& other) noexcept
    : mTextureName(std::move(other.mTextureName)),
    mTextureId(other.mTextureId) {
        other.mTextureId = 0;
    }
    GLTexture& operator=(const GLTexture& other) = delete;

    GLTexture& operator=(GLTexture&& other) noexcept {
        mTextureName = std::move(other.mTextureName);
        std::swap(mTextureId, other.mTextureId);
        return *this;
    }

    ~GLTexture() noexcept {
        if (mTextureId)
            glDeleteTextures(1, &mTextureId);
    }

    GLuint texture() const {
        return mTextureId;
    }

    const std::string& textureName() const {
        return mTextureName;
    }

    /**
     *  Load a file in memory and create an OpenGL texture.
     *  Returns a handle type (an std::unique_ptr) to the loaded pixels.
     */
    handleType load(const std::string& fileName, bool q, bool exf) {
        if (mTextureId) {
            glDeleteTextures(1, &mTextureId);
            mTextureId = 0;
        }
        int force_channels = 0;
        int w, h, n;
        handleType textureData(stbi_load(fileName.c_str(), &w, &h, &n, force_channels), stbi_image_free);
        if (!textureData) {
            throw std::invalid_argument("Could not load texture data from file " + fileName);
        }
        glGenTextures(1, &mTextureId);
        glBindTexture(GL_TEXTURE_2D, mTextureId);
        GLint internalFormat;
        GLint format;
        switch (n) {
            case 1: internalFormat = GL_R8;
                format = GL_RED;
                break;
            case 2: internalFormat = GL_RG8;
                format = GL_RG;
                break;
            case 3: internalFormat = GL_RGB8;
                format = GL_RGB;
                break;
            case 4: internalFormat = GL_RGBA8;
                format = GL_RGBA;
                break;
            default: internalFormat = 0;
                format = 0;
                break;
        }
        glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, w, h, 0, format, GL_UNSIGNED_BYTE, textureData.get());

        if (!exf) {
            if (!q) {
                glGenerateMipmap(GL_TEXTURE_2D);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
            } else {
                glGenerateMipmap(GL_TEXTURE_2D);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

            }
        } else {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        }
        return textureData;
    }

private:
    std::string mTextureName;
    GLuint mTextureId;
};



//------------------------
//scoreboard helper v1
extern "C" {

    const int c_max = 100;
    int c_i = 0;
    int c_gi = 0;
    int c_pages = 0;
    int c_color[] = {0, 0, 0};
    int c_r[c_max] = {0};
    int c_g[c_max] = {0};
    int c_b[c_max] = {0};
    char c_cc[100] = "";
    char c_name[100] = "";

    char *c_scoreboardlist[c_max];
    char *c_scoreboardlist1[c_max];
    char *c_scoreboardlist2[c_max];

    int c_setnamecolorx(char *js_nm, int js_valr, int js_valg, int js_valb, char *js_c) {
        c_color[0] = js_valr;
        c_color[1] = js_valg;
        c_color[2] = js_valb;
        strcpy(c_name, js_nm);
        strcpy(c_cc, js_c);
        return 0;
    }

    void c_free() {
        for (int i = 0; i < c_i; i++) {
            //delete[] c_scoreboardlist[i];
            free(c_scoreboardlist[i]);
            free(c_scoreboardlist1[i]);
            free(c_scoreboardlist2[i]);
        }
    }

    int c_boardlist(char *js_val, char *js_val2, char *js_val3, int r, int g, int b) {
        if (c_i < c_max) {
            c_scoreboardlist[c_i] = static_cast<char*> (malloc((strlen(js_val) + 1) * sizeof *c_scoreboardlist[c_i]));
            strcpy(c_scoreboardlist[c_i], js_val);
            c_scoreboardlist1[c_i] = static_cast<char*> (malloc((strlen(js_val2) + 1) * sizeof *c_scoreboardlist1[c_i]));
            strcpy(c_scoreboardlist1[c_i], js_val2);
            c_scoreboardlist2[c_i] = static_cast<char*> (malloc((strlen(js_val3) + 1) * sizeof *c_scoreboardlist2[c_i]));
            strcpy(c_scoreboardlist2[c_i], js_val3);
            c_r[c_i] = r;
            c_g[c_i] = g;
            c_b[c_i] = b;
            c_i++;
            c_gi++;
        } else {
            return 1;
        }
        return c_max - c_i;
    }

    int c_boardlistlength(int js_val) {
        c_pages = js_val;
        return 0;
    }

}

//C++
string ts = "";
string ts2 = "";
int k1[] = {11, 12, 50, 80, 30, 88, 77, 55, 12};
int k2[] = {62, 81, 30, 15, 2, 8, 51, 30, 20};

std::random_device rd;
std::mt19937 rng(rd());

string c_map = "123456789";

string replace(string word) {
    if (word.length() > 9)word.resize(9);
    string target = " ";
    string target2 = "\"";
    string target3 = "\'";
    string replacement = "_";
    int len, loop = 0;
    string nword = "", let;
    len = word.length();
    len--;
    while (loop <= len) {
        let = word.substr(loop, 1);
        if ((let == target) || (let == target2) || (let == target3)) {
            nword = nword + replacement;
        } else {
            nword = nword + let;
        }
        loop++;
    }
    return nword;
}

void postit(char *k1, char *k2, char *v1, char *v2, int mn, char *v3) {
    char t_string[1064] = "submitBoard(\"";
    strcat(t_string, k1);
    strcat(t_string, "\",\"");
    strcat(t_string, k2);
    strcat(t_string, "\",\"");
    strcat(t_string, v1);
    strcat(t_string, "\",\"");
    strcat(t_string, v2);
    strcat(t_string, "\",\"");
    char integer_string[32];
    sprintf(integer_string, "%d", mn);
    strcat(t_string, integer_string);
    strcat(t_string, "\",\"");
    strcat(t_string, v3);
    strcat(t_string, "\")");
    emscripten_run_script(t_string);
}

void addstring(string name, string score) {
    ts = "";
    ts2 = "";
    std::uniform_int_distribution<int> uni(0, c_map.length() - 1);
    for (int i = 0; i < c_map.length(); i++) {
        int randomNum = uni(rng);
        ts += c_map.substr(randomNum, 1);
    }
    char * tmpx = new char [ts.length() + 1];
    strcpy(tmpx, ts.c_str());
    for (int i = 0; i < c_map.length(); i++) {
        tmpx[i] += k1[i];
    }
    for (int i = 0; i < c_map.length(); i++) {
        tmpx[i] += k2[i];
    }
    ts2 = tmpx;
    int mn = 0;
    int tv1 = 0;
    int tv2 = 0;
    int tv3 = 0;
    char * xxx = new char [name.length() + 1];
    strcpy(xxx, name.c_str());
    char * mpx = new char [c_map.length() + 1];
    strcpy(mpx, c_map.c_str());
    char * yyy = new char [score.length() + 1];
    strcpy(yyy, score.c_str());
    char * key1xx = new char [ts.length() + 1];
    strcpy(key1xx, ts.c_str());
    char * key2xx = new char [ts2.length() + 1];
    strcpy(key2xx, ts2.c_str());
    postit(key1xx, key2xx, xxx, yyy, mn, c_cc);

}

float pfme = 0.;

class scoreboard_v_table {
public:
    nanogui::Window *scbwindow;
    nanogui::Button *nextb;
    nanogui::Button *prevb;
    nanogui::Button *closeb;
    nanogui::Button *tb;
    nanogui::Label *r1[c_max];
    nanogui::Label *r2[c_max];
    nanogui::Label *r3[c_max];
    nanogui::Label *pg;

    scoreboard_v_table(nanogui::Widget *scr) {
        using namespace nanogui;
        scbwindow = new Window(scr, "Scoreboard", false);
        scbwindow->setFixedSize(Vector2i(640, 510));
        scbwindow->setLayout(new BoxLayout(Orientation::Vertical, Alignment::Middle, 0, 10));
        Widget *header = new Widget(scbwindow);
        header->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
        Label *h1 = new Label(header, "Name", "sans-bold");
        h1->setColor(Color(230, 130, 180, 255));
        setsize1(h1);
        Label *h2 = new Label(header, "Score", "sans-bold");
        h2->setColor(Color(230, 130, 180, 255));
        setsize1(h2);
        Label *h3 = new Label(header, "Date", "sans-bold");
        h3->setColor(Color(230, 130, 180, 255));
        setsize1(h3);
        Label *h33 = new Label(header, "", "sans-bold");
        h33->setColor(Color(230, 130, 180, 255));
        h33->setFixedSize(Eigen::Vector2i(15, 20));
        VScrollPanel *tablescroll = new VScrollPanel(scbwindow);
        tablescroll->setFixedSize(Vector2i(640, 380));
        Widget *table = new Widget(tablescroll);
        table->setLayout(new BoxLayout(Orientation::Vertical, Alignment::Middle, 0, 10));
        for (int i = 0; i < c_max - 1; i++) {
            Widget *tableline = new Widget(table);
            tableline->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
            std::string str = "--------";
            r1[i] = new Label(tableline, str, "sans");
            setsize(r1[i]);
            r1[i]->setColor(Color(155, 250, 130, 255));
            r2[i] = new Label(tableline, str, "sans");
            setsize(r2[i]);
            r2[i]->setColor(Color(155, 250, 130, 255));
            r3[i] = new Label(tableline, str, "sans");
            setsize(r3[i]);
            r3[i]->setColor(Color(155, 250, 130, 255));
        }

        Widget *btns = new Widget(scbwindow);
        btns->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
        prevb = new Button(btns, "", ENTYPO_ICON_ARROW_LEFT);
        prevb->setCallback([&] {
            lpp();
            refresh();
        });
        tb = new Button(btns, "xxxx");

        tb->setCallback([&] {
            int scorex = pfme; //lost in callback
            string cnamex(c_name);
            string resm = "Name: " + cnamex + "\nScore: " + std::to_string(scorex) + "\nSave on server?";
            //can not use variable scr, it lost in this callback, this why scbwindow->parent
            auto dlg = new MessageDialog(scbwindow->parent(), MessageDialog::Type::Warning, "Final Score", resm, "Yes", "No", true);
            dlg->setCallback([&](int result) {
                if (result == 0) {
                    if (c_pages > 1) {
                        string namex(c_name);
                        string resm2 =std::to_string((int)pfme); //same lost "scorex" if use here
                        addstring(namex, resm2);
                        auto dlg = new MessageDialog(scbwindow->parent(), MessageDialog::Type::Information, "Done", "Request send.");
                        lfp();
                        refresh();
                    } else {
                        auto dlg = new MessageDialog(scbwindow->parent(), MessageDialog::Type::Warning, "Error", "Server Offline.");
                    }
                } else {
                }
            });
        });
        tb->setVisible(false);
        nextb = new Button(btns, "", ENTYPO_ICON_ARROW_RIGHT);
        nextb->setCallback([&] {
            lnp();
            refresh();
        });
        closeb = new Button(btns, "Close");
        closeb->setCallback([&] {
            scbwindow->setVisible(false);
        });
        pg = new Label(scbwindow, "Page: /", "sans-bold");
        pg->setFixedSize(Vector2i(600, 20));
        scbwindow->center();
        scbwindow->setVisible(false);



    }
    
    void lfpx(){
		lfp();
	}
	
	void refreshx(){
		refresh();
	}

private:

    void refresh() {
        for (int i = 0; i < c_max - 1; i++) {
            if (i < c_i) {
                r1[i]->setCaption(c_scoreboardlist[i]);
                r1[i]->setColor(nanogui::Color(c_r[i], c_g[i], c_b[i], 255));
                r2[i]->setCaption(c_scoreboardlist1[i]);
                r2[i]->setColor(nanogui::Color(c_r[i], c_g[i], c_b[i], 255));
                r3[i]->setCaption(c_scoreboardlist2[i]);
                r3[i]->setColor(nanogui::Color(c_r[i], c_g[i], c_b[i], 255));
            } else {
                std::string str = "--------";
                r1[i]->setCaption(str);
                r1[i]->setColor(nanogui::Color(155, 250, 130, 255));
                r2[i]->setCaption(str);
                r2[i]->setColor(nanogui::Color(155, 250, 130, 255));
                r3[i]->setCaption(str);
                r3[i]->setColor(nanogui::Color(155, 250, 130, 255));
            }
        }
        std::string str = "Page: ";

        str += std::to_string(c_gi / c_max + 1);
        str += "/";
        str += std::to_string(c_pages / c_max + 1);
        pg->setCaption(str);
    }

    void lfp() {
        if (c_gi > 0)c_free();
        c_i = 0;
        c_gi = 0;
        char integer_string[32];
        sprintf(integer_string, "%d)", c_gi);
        char t_string[64] = "printlist(";
        strcat(t_string, integer_string);
        emscripten_run_script(t_string);
    }

    void lnp() {
        if ((c_pages / c_max > 0)&&(c_gi != c_pages)) {
            c_free();
            c_i = 0;
            char integer_string[32];
            sprintf(integer_string, "%d)", c_gi);
            char t_string[64] = "printlist(";
            strcat(t_string, integer_string);
            emscripten_run_script(t_string);
        }
    }

    void lpp() {
        if ((c_pages / c_max > 0)&&(c_gi > c_max)) {
            c_free();
            c_gi = c_gi - c_i - c_max + 1;
            c_i = 0;
            char integer_string[32];
            sprintf(integer_string, "%d)", c_gi);
            char t_string[64] = "printlist(";
            strcat(t_string, integer_string);
            emscripten_run_script(t_string);
        }
    }

    void setsize(nanogui::Widget *val) {
        val->setFixedSize(Eigen::Vector2i(580 / 3, 20));
    }

    void setsize1(nanogui::Widget *val) {
        val->setFixedSize(Eigen::Vector2i(580 / 3, 20));
    }

};
//------------------------

Eigen::Vector2f rotate2d(float originx, float originy, float pointx, float pointy, float radian) {

    float s = std::sin(radian);
    float c = std::cos(radian);
    pointx -= originx;
    pointy -= originy;
    float xnew = pointx * c - pointy * s;
    float ynew = pointx * s + pointy * c;
    Eigen::Vector2f retval;
    retval[0] = xnew + originx;
    retval[1] = ynew + originy;
    return retval;

}

float angle2d(float cx, float cy, float ex, float ey) {
    float dy = ey - cy;
    float dx = ex - cx;
    float theta = std::atan2(dy, dx);
    return theta;
}


//globals to make lambda work
nanogui::CheckBox *cb;
nanogui::CheckBox *shdd;
nanogui::CheckBox *aacb;
nanogui::Button *b;
nanogui::Button *b1;
nanogui::Button *b2;
nanogui::Button *b3;
nanogui::ColorPicker *cp1;
nanogui::FloatBox<float> *ftextBox;
nanogui::Window *window1;
nanogui::TextBox *nametext;
nanogui::Button *nc;
scoreboard_v_table *stable;
bool paused = false;
bool resetx = true;
bool fxaa = true;
bool sdwsxd = true;
bool isend = false;
float pto = 0;
float ptime = 0;
bool antxtstate = true;
int indexfx[8] = {0};
Eigen::Vector2f umouse;
int plhp = 0;
const int maxhp = 23;

class box2dhelper {
public:
    float timeStep = 1.0f / 60.0f;
    int velocityIterations = 6;
    int positionIterations = 2;
    static const int maxobj = 2500;
    static const int maxlgth = 15; //200 work well
    int numobj = 0;
    int numlgths = 0;
    int gid = 0;
    float posx[maxobj] = {0};
    float playerpos[2] = {0};

    float posy[maxobj] = {0};
    float lposx[maxlgth] = {0};
    float lposy[maxlgth] = {0};
    float lfxposx[maxlgth] = {0};
    float lfxposy[maxlgth] = {0};
    float ttlx[maxlgth] = {0};
    int idx[maxlgth] = {0};
    int typex[maxobj] = {0};
    float rot[maxobj] = {0};
    const int WIDTH = 1366;
    const int HEIGHT = 768;
    int sWIDTH = 1366;
    int sHEIGHT = 768;
    float fposx = 0;
    float fposy = 0;
    float ttl = 30.;
    float spwnstart = 0;
    float lastspwn = 0;
    float lastbspwn = 0;
    int ntypex = 2;
    const float M2P = 30;
    const float P2M = 1 / M2P;
    int nxtpos = 1;
    float gmn = 0.;
    const int spmin = 2;
    const int spcd = 4;
    const int sptm = 110;
    int plrdm = 0;
    b2World* world;
    b2MouseJoint *mouseJoint;
    b2Body* grbody;
    b2Body* playerx;
    float playervtime = 0.;
    bool startani = false;
    bool spwnnew = false;
    float aniat = 0;

    struct myUserData {
        int idx; //its not id
        int health;
        int type;
        float ttl;
        float hitcd;
        float ishitcd;
    };

    class MContactListener : public b2ContactListener {

        void BeginContact(b2Contact* contact) {
            if (isend)return;
            myUserData* uS = (myUserData*) contact->GetFixtureA()->GetBody()->GetUserData();
            myUserData* uS2 = (myUserData*) contact->GetFixtureB()->GetBody()->GetUserData();
            if (uS) {
                if (uS2) {
                    if (((uS2->type == 4) || (uS->type == 4))&&((uS2->type == 3) || (uS->type == 3))) {
                        myUserData* mi = (uS2->type == 4) ? uS2 : uS;
                        myUserData* mi2 = (uS2->type == 3) ? uS2 : uS;
                        if ((float) glfwGetTime() - ptime - mi2->hitcd > mi2->ishitcd) {
                            mi2->hitcd = (float) glfwGetTime() - ptime;
                            if (mi->health < 1) {
                                isend = true;
                                pfme = glfwGetTime() - ptime;
                                std::function<void() > t = stable->tb->callback();
                                t();
                            }
                            mi->health--;


                        }
                    }
                }
            }
        }


    };

    MContactListener contactListenerInstance;

    int getlgth() {
        return maxlgth; //if get maxlgth from class, value bugged in my WASM build idk why(when other const work correctly), this why it exist...
    }

    void addplayer() {

        b2BodyDef bodydef;
        myUserData* myS = new myUserData;
        myS->type = 4;
        myS->health = maxhp;
        bodydef.position.Set(P2M * (WIDTH - 200) / 2., P2M * (HEIGHT - 200) / 2.);
        bodydef.type = b2_dynamicBody;
        playerx = world->CreateBody(&bodydef);
        b2CircleShape circle;
        circle.m_p.Set(0., 0.);
        circle.m_radius = P2M * 200.f / 2;
        b2FixtureDef fixturedef;
        fixturedef.density = 10.0;
        fixturedef.filter.maskBits = 0xFFFF;
        fixturedef.restitution = 1.f;
        fixturedef.friction = 0.0f;
        fixturedef.shape = &circle;
        playerx->SetUserData(myS);
        playerx->CreateFixture(&fixturedef);

        b2Vec2 bodypos = playerx->GetWorldCenter();
        b2MouseJointDef *mouseJointDef = new b2MouseJointDef;
        mouseJointDef->bodyA = grbody;
        mouseJointDef->bodyB = playerx;
        mouseJointDef->target.Set(bodypos.x, bodypos.y);
        mouseJointDef->maxForce = 0.45 * playerx->GetMass();
        mouseJointDef->frequencyHz = 10;
        mouseJoint = static_cast<b2MouseJoint*> (world->CreateJoint(mouseJointDef));

    }

    bool addObj(int x, int y, int w, int h, bool dyn = true, int typex = -1, float anx = 0.) {
        if (typex == -1)return false;
        if (typex == 3) {
            if (numlgths + 2 > maxlgth) {
                return false;
            }
        } else {
            if (numobj + 2 > maxobj) {
                return false;
            }
        }
        gid++;
        //for wasm/javascript...(it send max_long(or somethink big) as int(and box2d halt, becuse wrong verticles calculation on this numbers) if click in few first msec after page loaded)
        if ((x < 0 - WIDTH * 0.2) || (x > WIDTH + WIDTH * 0.2) || (y < 0 - HEIGHT * 0.2) || (y > HEIGHT + HEIGHT * 0.2)) {
            x = 0;
            y = 0;
        }
        b2BodyDef bodydef;
        myUserData* myS = new myUserData;
        myS->idx = plrdm;
        myS->ishitcd = 0.5;
        myS->hitcd = (float) glfwGetTime() - ptime;

        myS->type = typex;
        myS->ttl = (float) glfwGetTime() - ptime;
        bodydef.position.Set(x*P2M, y * P2M);
        if (dyn) {
            bodydef.type = b2_dynamicBody;
        }
        b2Body* body = world->CreateBody(&bodydef);

        b2PolygonShape shape;
        b2CircleShape circle;
        if (myS->type == 1) {
            shape.SetAsBox(P2M * w / 2, P2M * h / 2);
        } else if (myS->type == 2) {
            b2Vec2 vertices[3];
            vertices[0].Set(0, P2M * h / 2);
            vertices[1].Set(-P2M * w / 2, -P2M * h / 2);
            vertices[2].Set(P2M * w / 2, -P2M * h / 2);
            shape.Set(vertices, 3);
        } else if (myS->type == 0) {
            circle.m_p.Set(0, 0);
            circle.m_radius = P2M * w / 2;
        } else if (myS->type == 3) {
            circle.m_p.Set(0, 0);
            circle.m_radius = P2M * w / 2;
        }

        b2FixtureDef fixturedef;
        if (myS->type != 3) {
            fixturedef.density = 2.0 + 1.8 * myS->type;
            numobj++;
            //fixturedef.filter.maskBits = 0xFFFF & ~0x0008;
            fixturedef.friction = 0.3f;
        } else {
            fixturedef.density = 20.0;
            numlgths++;
            fixturedef.filter.maskBits = 0xFFFF;
            fixturedef.restitution = 1.f;
            fixturedef.friction = 0.0f;
        }
        if ((myS->type == 0) || (myS->type == 3)) {
            fixturedef.shape = &circle;
        } else {
            fixturedef.shape = &shape;
        }

        body->SetUserData(myS);
        body->CreateFixture(&fixturedef);
        if (myS->type != 3) {
            if (myS->type == 2)anx += M_PI / 8.;
            body->SetTransform(body->GetPosition(), anx);
            body->ApplyLinearImpulse(body->GetMass() * playerx->GetLinearVelocity() + body->GetMass() *(b2Vec2(((x - playerpos[0]) / (130 / fposx))*10., ((y - playerpos[1])) / (130 / fposx)*10.)), body->GetWorldCenter(), true);
        } else {
            std::uniform_int_distribution<int> uni2(0, 8);
            body->ApplyLinearImpulse(body->GetMass() * b2Vec2(uni2(rng) / 1.5, uni2(rng)), body->GetWorldCenter(), true);
        }
        return true;
    }

    void Edge() {

        b2BodyDef bodydef;
        bodydef.position.Set(0.f, HEIGHT * P2M);
        grbody = world->CreateBody(&bodydef);
        b2Vec2 v1(0.0f, 0.0f);
        b2Vec2 v2(WIDTH*P2M, 0.0f);
        b2EdgeShape edge;
        b2FixtureDef fixtureshape;
        fixtureshape.filter.categoryBits = 0x0002;
        //fixtureshape.filter.maskBits=4;
        fixtureshape.shape = &edge;
        fixtureshape.friction = 0.01f;
        edge.Set(v1, v2);
        grbody->CreateFixture(&fixtureshape);


        b2BodyDef bodydef0;
        bodydef0.position.Set(0.f, HEIGHT * P2M);
        b2Body* body = world->CreateBody(&bodydef0);
        b2Vec2 v10(0.0f, 0.0f);
        b2Vec2 v20(WIDTH*P2M, 0.0f);
        b2EdgeShape edge0;
        b2FixtureDef fixtureshape0;
        fixtureshape0.filter.categoryBits = 0x0002;
        //fixtureshape.filter.maskBits=4;
        fixtureshape0.shape = &edge0;
        fixtureshape0.friction = 0.01f;
        edge0.Set(v10, v20);
        body->CreateFixture(&fixtureshape0);


        b2BodyDef bodydef1;
        bodydef1.position.Set(0.f, HEIGHT * P2M);
        b2Body* body1 = world->CreateBody(&bodydef1);
        b2Vec2 v11(WIDTH * P2M * .07135, 0.0f);
        b2Vec2 v22(WIDTH * P2M * .07135, -HEIGHT * P2M);
        b2EdgeShape edge1;
        b2FixtureDef fixtureshape1;
        fixtureshape1.filter.categoryBits = 0x0008;
        //fixtureshape1.filter.maskBits=16;
        fixtureshape1.shape = &edge1;
        fixtureshape1.friction = 0.01f;

        edge1.Set(v11, v22);
        body1->CreateFixture(&fixtureshape1);

        b2BodyDef bodydef2;
        bodydef2.position.Set(0.f, HEIGHT * P2M);
        b2Body* body2 = world->CreateBody(&bodydef2);
        b2Vec2 v12(WIDTH*P2M, -HEIGHT * P2M);
        b2Vec2 v23(0.f, -HEIGHT * P2M);
        b2EdgeShape edge2;
        b2FixtureDef fixtureshape2;
        fixtureshape2.filter.categoryBits = 0x0002;
        //fixtureshape2.filter.maskBits=4;
        fixtureshape2.shape = &edge2;
        fixtureshape2.friction = 0.01f;

        edge2.Set(v12, v23);
        body2->CreateFixture(&fixtureshape2);

        b2BodyDef bodydef3;
        bodydef3.position.Set(0.f, HEIGHT * P2M);
        b2Body* body3 = world->CreateBody(&bodydef3);
        b2Vec2 v13(WIDTH * P2M - WIDTH * P2M * .07135, 0.0f);
        b2Vec2 v24(WIDTH * P2M - WIDTH * P2M * .07135, -HEIGHT * P2M);
        b2EdgeShape edge3;
        b2FixtureDef fixtureshape3;
        fixtureshape3.filter.categoryBits = 0x0008;
        //fixtureshape3.filter.maskBits=16;
        fixtureshape3.shape = &edge3;
        fixtureshape3.friction = 0.01f;

        edge3.Set(v13, v24);
        body3->CreateFixture(&fixtureshape3);



    }

    box2dhelper() {

    }

    void updpsize() {
        fposx = (float) sWIDTH / WIDTH;
        fposy = (float) sHEIGHT / HEIGHT;
    }

    void init() {
        updpsize();
        world = new b2World(b2Vec2(0.50f, 1.50f));
        Edge();
        addplayer();
        world->SetContactListener(&contactListenerInstance);
        spwnstart = glfwGetTime();

    }

    void spawnen() {
        float mn = ((float) glfwGetTime() - ptime - spwnstart) > sptm ? spmin : spmin + spcd * (1. - (((float) glfwGetTime() - ptime - spwnstart) / sptm));
        gmn = mn;
        if ((float) glfwGetTime() - ptime - lastspwn > mn) {
            float p = sWIDTH / 14;
            if (addObj((p + p * nxtpos + p / 2.) / fposx, (sHEIGHT / 8 / 2.) / fposy, 38, 38, true, 3)) {
                std::uniform_int_distribution<int> uni(0, 11);
                int cx = uni(rng);
                for (int ii = 0; (ii < 10)&&(cx == nxtpos); ii++)cx = uni(rng);
                lastspwn = (float) glfwGetTime() - ptime;
                nxtpos = cx;
                std::uniform_int_distribution<int> uni2(0, 1000);
                plrdm = uni2(rng);
            }
        }
    }

    void spawnewx() {
        if ((float) glfwGetTime() - ptime - lastbspwn > spmin / 10.f) {
            float an = angle2d(playerpos[0] * fposx, playerpos[1] * fposy, umouse[0], umouse[1]);
            Eigen::Vector2f np = rotate2d(playerpos[0] * fposx, playerpos[1] * fposy, playerpos[0] * fposx + 0, playerpos[1] * fposy + 120.0f * fposx, -M_PI / 2. + an);
            if (addObj(np[0] / fposx, np[1] / fposy, 38, 38, true, ntypex, an)) {
                lastbspwn = (float) glfwGetTime() - ptime;
            }
        }
    }

    void tickani() {
        if (startani&&(glfwGetTime() - ptime>6.)) {
            if (playervtime - aniat < 1.) {
                ntypex = 2;
                switch ((int) playervtime + 1) {
                    case 1:ntypex = 0;
                        break;
                    case 2:ntypex = 1;
                        break;
                    case 3:ntypex = 2;
                        break;
                }
                playervtime += timeStep;
                if (playervtime > 3) {
                    playervtime = 0;
                    ntypex = 2;
                    aniat = playervtime;
                    startani = false;
                }
            } else {
                switch ((int) playervtime) {
                    case 1:ntypex = 0;
                        break;
                    case 2:ntypex = 1;
                        break;
                    case 3:ntypex = 2;
                        break;
                }
                playervtime = (int) playervtime;
                aniat = playervtime;
                startani = false;
            }
        }
    }

    void resetxx() {
        if (resetx) {
            b2Body* tmp = world->GetBodyList();
            while (tmp) {
                b2Body* b = tmp;
                tmp = tmp->GetNext();
                myUserData* uS = (myUserData*) b->GetUserData();
                if (uS) {
                    if (uS->type != 4) {
                        if (uS->type != 3) {
                            delete uS;
                            world->DestroyBody(b);
                            numobj--;
                        } else {
                            delete uS;
                            world->DestroyBody(b);
                            numlgths--;
                        }
                    }
                }
            }
            lastspwn = 0;
            aniat = 0;
            playervtime = 0.;
            gmn = 0;
            nxtpos = 1;
            ntypex = 2;
            lastbspwn = 0;
            spwnstart = 0;
            myUserData* uS = (myUserData*) playerx->GetUserData();
            playerx->SetLinearVelocity(b2Vec2(0, 0));
            playerx->SetAngularVelocity(0);
            playerx->SetTransform(b2Vec2(P2M * (WIDTH) / 2., P2M * (HEIGHT) / 2.), 0);
            uS->health = maxhp;
            isend = false;
            pfme = 0.;


        }
    }

    void updateposxy() {
        b2Body* tmp = world->GetBodyList();
        int ix = 0;
        int ixl = 0;
        while (tmp) {
            b2Body* b = tmp;
            tmp = tmp->GetNext();
            b2Vec2 position = b->GetPosition();
            float32 angle = b->GetAngle();

            myUserData* uS = (myUserData*) b->GetUserData();
            if (uS) {
                if (uS->type == 4) {
                    playerpos[0] = position.x*M2P;
                    playerpos[1] = position.y*M2P;
                    plhp = uS->health;
                } else {
                    if (uS->type != 3) {
                        posx[ix] = position.x*M2P;
                        posy[ix] = position.y*M2P;
                        typex[ix] = uS->type;
                        rot[ix] = angle;

                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl * 3.) || (posx[ix] < 0.f - WIDTH * 0.2) || (posy[ix] < 0.f - HEIGHT * 0.2) || (posx[ix] > WIDTH + WIDTH * 0.2) || (posy[ix] > HEIGHT + HEIGHT * 0.2)) {

                        } else {
                            ix++;
                        }
                    } else {
                        lposx[ixl] = position.x*M2P;
                        ttlx[ixl] = ((float) glfwGetTime() - ptime - uS->ttl) / ttl;
                        ttlx[ixl] = ttlx[ixl] > 1. ? 1. : ttlx[ixl];
                        lposy[ixl] = position.y*M2P;
                        lfxposx[ixl] = (position.x * M2P * fposx);
                        lfxposy[ixl] = (position.y * M2P * fposy);
                        idx[ixl] = uS->idx;
                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl * 3.) || (lposx[ixl] < 0.f - WIDTH * 0.2) || (lposy[ixl] < 0.f - HEIGHT * 0.2) || (lposx[ixl] > WIDTH + WIDTH * 0.2) || (lposy[ixl] > HEIGHT + HEIGHT * 0.2)) {
                        } else {
                            ixl++;
                        }
                    }
                }
            }

        }
    }

    void ticknext() {
        if (paused)return;
        resetxx();
        if (!isend)spawnen();
        if (!isend)tickani();
        if (isend)playerx->SetAwake(false);
        if (spwnnew) {
            if (!isend&&(glfwGetTime() - ptime>6.))spawnewx();
            spwnnew = false;
        }
        world->Step(timeStep, velocityIterations, positionIterations);
        b2Body* tmp = world->GetBodyList();
        b2Vec2 points[4];
        int ix = 0;
        int ixl = 0;
        float an = angle2d(playerpos[0] * fposx, playerpos[1] * fposy, umouse[0], umouse[1]);
        Eigen::Vector2f np = rotate2d(playerpos[0] * fposx, playerpos[1] * fposy, playerpos[0] * fposx + 0, playerpos[1] * fposy + 120.0f * fposx, -M_PI / 2. + an);

        b2Vec2 p2 = b2Vec2((P2M * np[0]) / fposx, (P2M * np[1]) / fposx);
        if (!isend)mouseJoint->SetTarget(p2);
        while (tmp) {
            b2Body* b = tmp;
            tmp = tmp->GetNext();
            b2Vec2 position = b->GetPosition();
            float32 angle = b->GetAngle();

            myUserData* uS = (myUserData*) b->GetUserData();
            if (uS) {
                if (uS->type == 4) {
                    playerpos[0] = position.x*M2P;
                    playerpos[1] = position.y*M2P;
                    plhp = uS->health;
                    b->ApplyForce(b->GetMass() * -world->GetGravity(),
                            b->GetWorldCenter(), true);
                } else {
                    if (uS->type != 3) {
                        posx[ix] = position.x*M2P;
                        posy[ix] = position.y*M2P;
                        typex[ix] = uS->type;
                        rot[ix] = angle;
                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl / 5.f)) {
                            b2Fixture *tempF = b->GetFixtureList();
                            b2Filter temp = tempF->GetFilterData();
                            temp.maskBits = 0xFFFF & ~0x0008;
                            tempF->SetFilterData(temp);
                        }

                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl * 3.) || (posx[ix] < 0.f - WIDTH * 0.2) || (posy[ix] < 0.f - HEIGHT * 0.2) || (posx[ix] > WIDTH + WIDTH * 0.2) || (posy[ix] > HEIGHT + HEIGHT * 0.2)) {
                            delete uS;
                            world->DestroyBody(b);
                            numobj--;
                        } else {
                            ix++;
                        }
                    } else {
                        lposx[ixl] = position.x*M2P;
                        ttlx[ixl] = ((float) glfwGetTime() - ptime - uS->ttl) / ttl;
                        ttlx[ixl] = ttlx[ixl] > 1. ? 1. : ttlx[ixl];
                        lposy[ixl] = position.y*M2P;
                        lfxposx[ixl] = (position.x * M2P * fposx);
                        lfxposy[ixl] = (position.y * M2P * fposy);
                        idx[ixl] = uS->idx;
                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl)) {
                            b2Fixture *tempF = b->GetFixtureList();
                            b2Filter temp = tempF->GetFilterData();
                            temp.maskBits = 0xFFFF & ~0x0008;
                            tempF->SetFilterData(temp);
                            b->ApplyForce(b->GetMass() * -world->GetGravity(),
                                    b->GetWorldCenter(), true);
                            b->ApplyForce(b->GetMass() * b2Vec2(.65f, -1.f), b->GetWorldCenter(), true);
                        } else {
                            b->ApplyForce(b->GetMass() * -world->GetGravity(),
                                    b->GetWorldCenter(), true);
                            b->ApplyForce(b->GetMass() * b2Vec2(-0.1 + 1.28 * ttlx[ixl] * std::sin((float) glfwGetTime() - ptime / 2. + ixl), 0.25f - 2.5 * ttlx[ixl] * std::sin(-(float) glfwGetTime() - ptime / 2. + ixl)), b->GetWorldCenter(), true);
                        }
                        if (((float) glfwGetTime() - ptime - uS->ttl > ttl * 3.) || (lposx[ixl] < 0.f - WIDTH * 0.2) || (lposy[ixl] < 0.f - HEIGHT * 0.2) || (lposx[ixl] > WIDTH + WIDTH * 0.2) || (lposy[ixl] > HEIGHT + HEIGHT * 0.2)) {
                            delete uS;
                            world->DestroyBody(b);
                            numlgths--;
                        } else {
                            ixl++;
                        }
                    }
                }
            }

        }
    }
};

class animehelper {
public:

    //background values

    const float clicktime = 2.5;
    const float fadetime = 1;
    bool backgroundVisible = false;
    bool backgroundAnimstate = false;
    bool backgroundisclick[4] = {0};
    float backgroundclicktimershift[4] = {0};
    float backgoundClickpos1[2] = {0};
    float backgoundClickpos2[2] = {0};
    float backgoundClickpos3[2] = {0};
    float backgoundClickpos4[2] = {0};
    float backgroundShifttime = 0;
    bool drawonce = true;

    animehelper() {


    }

    void addbackgroundClick(float t, float x, float y) {
        for (int i = 0; i < 4; i++) {
            if (!backgroundisclick[i]) {
                backgroundisclick[i] = true;
                backgroundclicktimershift[i] = t;
                switch (i) {
                    case 0: backgoundClickpos1[0] = x;
                        backgoundClickpos1[1] = y;
                        break;
                    case 1: backgoundClickpos2[0] = x;
                        backgoundClickpos2[1] = y;
                        break;
                    case 2: backgoundClickpos3[0] = x;
                        backgoundClickpos3[1] = y;
                        break;
                    case 3: backgoundClickpos4[0] = x;
                        backgoundClickpos4[1] = y;

                        break;
                }
                break;
            }
        }
    }

    void resetbackgroundUniforms() {
        backgroundAnimstate = false;
        backgroundShifttime = 0;
        backgroundVisible = false;
        paused = backgroundVisible;
        if (paused)pto = glfwGetTime();
        else {
            ptime = ptime + glfwGetTime() - pto;
            pto = 0;
        }

        for (int i = 0; i < 4; i++) {

            backgroundisclick[i] = false;
        }
    }

    void updatebackgroundUniforms(float t) {
        if (backgroundShifttime == 0)backgroundShifttime = t;

        for (int i = 0; i < 4; i++) {
            if (backgroundisclick[i]&&(t - backgroundclicktimershift[i] > clicktime)) {
                backgroundisclick[i] = false;
            }
        }
        if (backgroundAnimstate)if (1.f - (t - backgroundShifttime) < 0) {

                resetbackgroundUniforms();
            }
    }
};

class Ccgm : public nanogui::Screen {
public:

    Ccgm() : nanogui::Screen(Eigen::Vector2i(1366, 768), "NanoGUI Test", /*resizable*/true, /*fullscreen*/false, /*colorBits*/8,
    /*alphaBits*/8, /*depthBits*/24, /*stencilBits*/8,
    /*nSamples*/0, /*glMajor*/3, /*glMinor*/0) {
        using namespace nanogui;
        window1 = new Window(this, "Menu");
        initall();
        settextures();
        setBackground(Vector4f(0, 0, 0, 1));
        stable = new scoreboard_v_table(this);
        b = new Button(this, "Menu");
        b->setBackgroundColor(Color(235, 0, 0, 155));
        b->setTextColor(Color(235, 235, 235, 255));
        b->setCallback([&] {
            window1->setVisible(!window1->visible());
            if (window1->visible()) {
                window1->center();
            } else {
                stable->scbwindow->setVisible(false);
            }
        });
        b->setFixedSize(Eigen::Vector2i(63, 30));

        b1 = this->add<Button>("Pause");
        b1->setBackgroundColor(Color(0, 0, 205, 155));
        b1->setTextColor(Color(235, 235, 235, 255));
        b1->setPosition(Vector2i(0, 35));
        b1->setFixedSize(Eigen::Vector2i(63, 30));
        b1->setCallback([&] {

            if (ahelper->backgroundVisible) {
                ahelper->backgroundAnimstate = !ahelper->backgroundAnimstate;
                if (glfwGetTime() - ahelper->backgroundShifttime > ahelper->fadetime) {
                    ahelper->backgroundShifttime = (float) glfwGetTime();
                } else {
                    ahelper->backgroundShifttime = (float) glfwGetTime() - (ahelper->fadetime - ((float) glfwGetTime() - ahelper->backgroundShifttime));
                }
            } else {
                ahelper->backgroundVisible = true;
                ahelper->drawonce = true;
                paused = ahelper->backgroundVisible;
                if (paused)pto = glfwGetTime();
                else {
                    ptime = ptime + glfwGetTime() - pto;
                    pto = 0;
                }

            }
        });

        b2 = this->add<Button>("Reset");
        b2->setTextColor(Color(235, 235, 235, 255));
        b2->setBackgroundColor(Color(205, 100, 0, 155));
        b2->setPosition(Vector2i(65, 0));
        b2->setFixedSize(Eigen::Vector2i(63, 30));
        b2->setCallback([&] {
            if (!paused) {
                resetx = true;
            } else {
                auto dlg = new MessageDialog(b2->parent(), MessageDialog::Type::Information, "!!", "Unpause first!");
            }

        });

        window1->setPosition(Vector2i(425, 300));
        GridLayout *layout =
                new GridLayout(Orientation::Horizontal, 2,
                Alignment::Middle, 15, 5);
        layout->setColAlignment({Alignment::Maximum, Alignment::Fill});
        layout->setSpacing(0, 10);
        window1->setLayout(layout);

        nc = new Button(window1, "Name :");
        nametext = new TextBox(window1);
        //Label *nc = new Label(window1, "Name :", "sans-bold");
        nc->setTextColor(Color(c_color[0], c_color[1], c_color[2], 255));
        nc->setFixedSize(Vector2i(100, 20));
        nc->setTooltip("click to random");
        nc->setCallback([&] {
            emscripten_run_script("generate()");
            nametext->setValue(c_name);
            nc->setTextColor(Color(c_color[0], c_color[1], c_color[2], 255));
        });

        nametext->setEditable(true);
        nametext->setFixedSize(Vector2i(100, 20));
        nametext->setValue(c_name);
        nametext->setDefaultValue(c_name);
        nametext->setTooltip("EN max 9 chars");
        nametext->setCallback([&](string str) {
            str = replace(str);
            strcpy(c_name, str.c_str());
            return true;
        });
        new Label(window1, "Hide Menu buttons :", "sans-bold");

        cb = new CheckBox(window1, "");
        cb->setFontSize(16);
        cb->setChecked(false);
        cb->setCallback([&](bool state) {
            if (!state) {
                b->setVisible(true);
                b1->setVisible(true);
                b2->setVisible(true);
            } else {
                b->setVisible(false);
                b1->setVisible(false);
                b2->setVisible(false);
            }
        });
        new Label(window1, "Shadows (on/off) :", "sans-bold");

        shdd = new CheckBox(window1, "");
        shdd->setFontSize(16);
        shdd->setChecked(true);
        shdd->setCallback([&](bool state) {
            sdwsxd = state;
            ahelper->drawonce = true;
        });

        new Label(window1, "FXAA+Bloom (on/off) :", "sans-bold");

        aacb = new CheckBox(window1, "");
        aacb->setFontSize(16);
        aacb->setChecked(true);
        aacb->setCallback([&](bool state) {
            fxaa = state;
            ahelper->drawonce = true;
        });
        new Label(window1, "Control :", "sans-bold");
        new Label(window1, "Use mouse :)", "sans-bold");
        b3 = new Button(window1, "Leaderboard");
        b3->setCallback([&] {
			stable->lfpx();
			stable->refreshx();

            window1->setVisible(false);
            stable->scbwindow->center();
            stable->scbwindow->setVisible(!stable->scbwindow->visible());
            stable->scbwindow->requestFocus();
        });

        performLayout();
        window1->setVisible(false);

        fb1.inittexture(Vector2i(1280, 720), true);
        fblg.inittexture(Vector2i(1280, 720));
        sdfb.inittexture(Vector2i(1280, 720));
        sdfb2.inittexture(Vector2i(1280, bhelper->getlgth() + 4), true);
        cpfb.inittexture(Vector2i(1280, 720));
        nvfb.inittexture(Vector2i(1280, 720));
        bl1.inittexture(Vector2i(1280, 720));
        bl2.inittexture(Vector2i(1280, 720));
        bl3.inittexture(Vector2i(1280, 720));
        nvmfb.inittexture(Vector2i(1280, 720));

        mShader2.initFromFiles("mfb", "shaders/mainv.glsl", "shaders/mainfb.glsl");
        mShader.initFromFiles("mf", "shaders/mainv.glsl", "shaders/mainf.glsl");
        mShader3.initFromFiles("mbg", "shaders/mainv.glsl", "shaders/mainbg.glsl");
        clb.initFromFiles("clb", "shaders/mainv.glsl", "shaders/clb.glsl");
        sb1.initFromFiles("sb1", "shaders/mainv.glsl", "shaders/sb.glsl");
        cpshd.initFromFiles("cpshd", "shaders/mainv.glsl", "shaders/cpshd.glsl");
        nvfxaa.initFromFiles("nvfxaa", "shaders/mainv.glsl", "shaders/nvfxaa.glsl");
        blaa1.initFromFiles("blaa1", "shaders/mainv.glsl", "shaders/blaa1.glsl");
        blaa2.initFromFiles("blaa2", "shaders/mainv.glsl", "shaders/blaa2.glsl");
        blaa3.initFromFiles("blaa3", "shaders/mainv.glsl", "shaders/blaa3.glsl");
        lgshd.initFromFiles("lgshd", "shaders/mainv.glsl", "shaders/mainfblg.glsl");

        MatrixXu indices(3, 2); /* Draw 2 triangles */
        indices.col(0) << 0, 1, 2;
        indices.col(1) << 2, 3, 0;

        MatrixXf positions(3, 4);
        positions.col(0) << -1, -1, 0;
        positions.col(1) << 1, -1, 0;
        positions.col(2) << 1, 1, 0;
        positions.col(3) << -1, 1, 0;
        Vector2f screenSize = size().cast<float>();

        fb1.bind();
        mShader2.bind();
        mShader2.uploadIndices(indices);
        mShader2.uploadAttrib("position", positions);
        mShader2.setUniform("u_resolution", screenSize);
        fb1.release();

        fblg.bind();
        lgshd.bind();
        lgshd.uploadIndices(indices);
        lgshd.uploadAttrib("position", positions);
        lgshd.setUniform("u_resolution", screenSize);
        fblg.release();

        bl1.bind();
        blaa1.bind();
        blaa1.uploadIndices(indices);
        blaa1.uploadAttrib("position", positions);
        blaa1.setUniform("u_resolution", screenSize);
        bl1.release();

        bl2.bind();
        blaa2.bind();
        blaa2.uploadIndices(indices);
        blaa2.uploadAttrib("position", positions);
        blaa2.setUniform("u_resolution", screenSize);
        bl2.release();

        bl3.bind();
        blaa3.bind();
        blaa3.uploadIndices(indices);
        blaa3.uploadAttrib("position", positions);
        blaa3.setUniform("u_resolution", screenSize);
        bl3.release();


        nvfb.bind();
        mShader3.bind();
        mShader3.uploadIndices(indices);
        mShader3.uploadAttrib("position", positions);
        mShader3.setUniform("u_resolution", screenSize);
        nvfb.release();

        nvmfb.bind();
        mShader.bind();
        mShader.uploadIndices(indices);
        mShader.uploadAttrib("position", positions);
        mShader.setUniform("u_resolution", screenSize);
        nvmfb.release();

        cpfb.bind();
        cpshd.bind();
        cpshd.uploadIndices(indices);
        cpshd.uploadAttrib("position", positions);
        cpshd.setUniform("u_resolution", screenSize);
        cpfb.release();

        sdfb.bind();
        clb.bind();
        clb.uploadIndices(indices);
        clb.uploadAttrib("position", positions);
        clb.setUniform("u_resolution", screenSize);
        sdfb.release();

        sdfb2.bind();
        sb1.bind();
        sb1.uploadIndices(indices);
        sb1.uploadAttrib("position", positions);
        sb1.setUniform("u_resolution", screenSize);
        sdfb2.release();

        /*fb2.bind();
        mShader3.bind();
        mShader3.uploadIndices(indices);
        mShader3.uploadAttrib("position", positions);
        mShader3.setUniform("u_resolution", screenSize);

        fb2.release();

        fb3.bind();
        mShader4.bind();
        mShader4.uploadIndices(indices);
        mShader4.uploadAttrib("position", positions);
        mShader4.setUniform("u_resolution", screenSize);

        fb3.release();

        fb4.bind();
        mShader5.bind();
        mShader5.uploadIndices(indices);
        mShader5.uploadAttrib("position", positions);
        mShader5.setUniform("u_resolution", screenSize);

        fb4.release();

        fb5.bind();
        mShader6.bind();
        mShader6.uploadIndices(indices);
        mShader6.uploadAttrib("position", positions);

        fb5.release();

        fb6.bind();
        mShader7.bind();
        mShader7.uploadIndices(indices);
        mShader7.uploadAttrib("position", positions);
        mShader7.setUniform("u_resolution", screenSize);

        fb6.release();

        fb7.bind();
        mShader8.bind();
        mShader8.uploadIndices(indices);
        mShader8.uploadAttrib("position", positions);
        mShader8.setUniform("u_resolution", screenSize);

        fb7.release();

        fb8.bind();
        mShader9.bind();
        mShader9.uploadIndices(indices);
        mShader9.uploadAttrib("position", positions);
        mShader9.setUniform("u_resolution", screenSize);

        fb8.release();

        fb9.bind();
        mShader10.bind();
        mShader10.uploadIndices(indices);
        mShader10.uploadAttrib("position", positions);

        fb9.release();

        fb10.bind();
        mShader11.bind();
        mShader11.uploadIndices(indices);
        mShader11.uploadAttrib("position", positions);
        mShader11.setUniform("u_resolution", screenSize);

        fb10.release();

        fb11.bind();
        mShader12.bind();
        mShader12.uploadIndices(indices);
        mShader12.uploadAttrib("position", positions);
        mShader12.setUniform("u_resolution", screenSize);

        fb11.release();

        fb12.bind();
        mShader13.bind();
        mShader13.uploadIndices(indices);
        mShader13.uploadAttrib("position", positions);
        mShader13.setUniform("u_resolution", screenSize);

        fb12.release();

        fb13.bind();
        mShader14.bind();
        mShader14.uploadIndices(indices);
        mShader14.uploadAttrib("position", positions);
        mShader14.setUniform("u_resolution", screenSize);

        fb13.release();*/


        nvfxaa.bind();
        nvfxaa.uploadIndices(indices);
        nvfxaa.uploadAttrib("position", positions);
        nvfxaa.setUniform("u_resolution", screenSize);
    }

    ~Ccgm() {

        //mShader.free();
    }

    virtual bool keyboardEvent(int key, int scancode, int action, int modifiers) {
        if (Screen::keyboardEvent(key, scancode, action, modifiers))
            return true;
        if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
            //std::cout<<"Exit(ESC) called"<<std::endl;
            //setVisible(false);
            return true;
        }
        if (key == GLFW_KEY_P && action == GLFW_PRESS) {
            if (ahelper->backgroundVisible) {
                ahelper->backgroundAnimstate = !ahelper->backgroundAnimstate;
                if (glfwGetTime() - ahelper->backgroundShifttime > ahelper->fadetime) {
                    ahelper->backgroundShifttime = (float) glfwGetTime();
                } else {
                    ahelper->backgroundShifttime = (float) glfwGetTime() - (ahelper->fadetime - ((float) glfwGetTime() - ahelper->backgroundShifttime));
                }
            } else {
                ahelper->backgroundVisible = true;
                ahelper->drawonce = true;
                paused = ahelper->backgroundVisible;
                if (paused)pto = glfwGetTime();
                else {
                    ptime = ptime + glfwGetTime() - pto;
                    pto = 0;
                }
            }

            return true;
        }

        return false;
    }

    virtual bool mouseMotionEvent(const Eigen::Vector2i &p, const Eigen::Vector2i &rel, int button, int modifiers) {
        if (Screen::mouseMotionEvent(p, rel, button, modifiers)) {
            return true;
        }
        //if ((button & (1 << GLFW_MOUSE_BUTTON_1)) != 0) {
        umouse = Eigen::Vector2f(p[0], p[1]);
        if (cb->checked()) {
            if (p[0] < 130 && p[1] < 80) {
                b->setVisible(true);
                b1->setVisible(true);
                b2->setVisible(true);
            } else {

                b->setVisible(false);
                b1->setVisible(false);
                b2->setVisible(false);
            }
        }
        //return true;
        //}
        return false;
    }
    float ffm = false;

    virtual bool mouseButtonEvent(const Eigen::Vector2i &p, int button, bool down, int modifiers) {
        if (Screen::mouseButtonEvent(p, button, down, modifiers))
            return true;
        ffm = button == GLFW_MOUSE_BUTTON_1 && down;
        if (ffm) {
            if (ahelper->backgroundVisible) {
                if ((float) glfwGetTime() - ahelper->backgroundShifttime > 1) {
                    ahelper->addbackgroundClick((float) glfwGetTime(), p[0], p[1]);
                }
            } else {

            }
        }
        return false;
    }

    virtual void draw(NVGcontext *ctx) {

        /* Draw the user interface */
        Screen::draw(ctx);
    }

    double frameRateSmoothing = 1.0;
    double numFrames = 0;
    double fps = 60;

    Eigen::Vector2f osize = Eigen::Vector2f(1280, 720);
    bool scrch = true;

    virtual void drawContents() {
        using namespace nanogui;

        std::chrono::duration<double> delta = std::chrono::duration_cast<std::chrono::duration<double>> (std::chrono::high_resolution_clock::now() - lastFpsTime);
        numFrames++;
        if (delta.count() > frameRateSmoothing) {
            fps = (int) (numFrames / delta.count());
            fps = fps < 30 ? 30 : fps;
            bhelper->timeStep = 1. / (fps);
            numFrames = 0;
            lastFpsTime = std::chrono::high_resolution_clock::now();
        }

        if (resetx)ptime = glfwGetTime();
        updateallUnioforms();
        if (ffm) {
            bhelper->spwnnew = true;
        } else {
            bhelper->startani = true;
        }
        Vector2i tsxz = size();
        if ((int) (tsxz[1]*(float) 16 / 9) != tsxz[0]) {
            tsxz[0] = (int) (tsxz[1]*(float) 16 / 9);
            bhelper->sWIDTH = tsxz[0];
            bhelper->sHEIGHT = tsxz[1];
            bhelper->updpsize();
        }
        if (scrch) {
            bhelper->sWIDTH = tsxz[0];
            bhelper->sHEIGHT = tsxz[1];
            bhelper->updpsize();
        }
        Vector2f screenSize = tsxz.cast<float>();
        glDisable(GL_BLEND); //framebuffer


        if (ahelper->backgroundVisible) {
            //fix resolution
            sdfb.bindtexture(tsxz, 0);
            fblg.bindtexture(tsxz, 0);
            sdfb.bindtexture(tsxz, 0);
            fblg.bindtexture(tsxz, 0);
            if (sdwsxd) sdfb2.bindtexture(Vector2i(tsxz[0], bhelper->getlgth() + 4), 1);
            if (fxaa) nvfb.bindtexture(tsxz, 0);
            if (fxaa) bl1.bindtexture(tsxz, 0);
            if (fxaa) bl2.bindtexture(tsxz, 0);
            if (fxaa) bl3.bindtexture(tsxz, 0);
            fb1.bindtexture(tsxz, 0);
            if (scrch || ahelper->drawonce) {
                bhelper->updateposxy();
                sdfb.bind();
                clb.bind();
                clb.setUniform("u_resolution", screenSize);
                clb.drawIndexed(GL_TRIANGLES, 0, 2);
                clb.setUniform("playerpos", Vector2f(bhelper->playerpos[0] * bhelper->fposx, bhelper->playerpos[1] * bhelper->fposy));
                //glClearColor(.5, 0., 0., 1.);
                //glClear(GL_COLOR_BUFFER_BIT);
                sdfb.release();
                sdfb.blittexture();
                glEnable(GL_DEPTH_TEST);
                glEnable(GL_BLEND);
                fblg.bind();
                glClearColor(0., 0., 0., 1.);
                glClear(GL_COLOR_BUFFER_BIT);
                fblg.release();
                fblg.blittexture();
                for (int i = 0; i < bhelper->numobj; i++) {
                    glViewport(bhelper->posx[i] * bhelper->fposx - 27 * bhelper->fposx,
                            tsxz[1] - bhelper->posy[i] * bhelper->fposy - 27 * bhelper->fposx,
                            54 * bhelper->fposx, 54 * bhelper->fposx);
                    sdfb.bind();
                    mShader2.bind();
                    mShader2.setUniform("u_resolution", screenSize);
                    mShader2.setUniform("pos", Vector2f(screenSize[0] - bhelper->posx[i] * bhelper->fposx, screenSize[1] - bhelper->posy[i] * bhelper->fposy));
                    mShader2.setUniform("rot", bhelper->rot[i]);
                    mShader2.setUniform("viuu", bhelper->typex[i]);
                    mShader2.drawIndexed(GL_TRIANGLES, 0, 2);
                    sdfb.release();
                    sdfb.blittexture();
                }

                for (int i = 0; i < bhelper->numlgths; i++) {
                    glViewport(bhelper->lposx[i] * bhelper->fposx - 27 * bhelper->fposx,
                            tsxz[1] - bhelper->lposy[i] * bhelper->fposy - 27 * bhelper->fposx,
                            54 * bhelper->fposx, 54 * bhelper->fposx);
                    fblg.bind();
                    lgshd.bind();
                    lgshd.setUniform("u_resolution", screenSize);
                    lgshd.setUniform("ttl", bhelper->ttlx[i]);
                    lgshd.setUniform("isspwnr", false);
                    lgshd.setUniform("pos", Vector2f(screenSize[0] - bhelper->lposx[i] * bhelper->fposx, screenSize[1] - bhelper->lposy[i] * bhelper->fposy));
                    lgshd.setUniform("u_time", (float) (float) pto - ptime + bhelper->idx[i]);
                    lgshd.drawIndexed(GL_TRIANGLES, 0, 2);
                    fblg.release();
                    fblg.blittexture();

                }
                float p = bhelper->sWIDTH / 14;
                glViewport((p + p * bhelper->nxtpos + p / 2.) - 27 * bhelper->fposx,
                        tsxz[1] - (bhelper->sHEIGHT / 8. / 2.) - 27 * bhelper->fposx,
                        54 * bhelper->fposx, 54 * bhelper->fposx);
                fblg.bind();
                lgshd.bind();
                lgshd.setUniform("u_resolution", screenSize);
                float tpx = ((float) pto - ptime - bhelper->lastspwn);
                lgshd.setUniform("ttl", (tpx / (bhelper->gmn)) > 1. ? 1. : (tpx / (bhelper->gmn)));
                lgshd.setUniform("isspwnr", true);

                lgshd.setUniform("pos", Vector2f(screenSize[0] -(p + p * bhelper->nxtpos + p / 2.), screenSize[1] -(bhelper->sHEIGHT / 8. / 2.)));
                lgshd.setUniform("u_time", (float) (float) pto - ptime + bhelper->plrdm);
                lgshd.drawIndexed(GL_TRIANGLES, 0, 2);
                fblg.release();
                fblg.blittexture();



                glDisable(GL_BLEND);
                glDisable(GL_DEPTH_TEST);
                glViewport(0, 0, screenSize[0], bhelper->getlgth() + 4);

                if (sdwsxd) {
                    sdfb2.bind();
                    sb1.bind();
                    sdfb.bindtexture(tsxz, 0);
                    sb1.setUniform("u_texture2", 0);
                    sb1.setUniform("u_time", (float) (float) pto - ptime);
                    //sb1.setUniform("u_mouse", umouse);
                    sb1.setUniformFloatArray("lposx", bhelper->lfxposx, bhelper->numlgths);
                    sb1.setUniformFloatArray("lposy", bhelper->lfxposy, bhelper->numlgths);
                    sb1.setUniformFloatArray("ttlx", bhelper->ttlx, bhelper->numlgths);
                    sb1.setUniform("numlgths", bhelper->numlgths);
                    sb1.setUniform("fkres", screenSize);
                    sb1.setUniform("u_resolution", Vector2f(screenSize[0], bhelper->getlgth() + 4));
                    sb1.drawIndexed(GL_TRIANGLES, 0, 2);
                    sdfb2.release();
                    sdfb2.blittexture();
                }
                glViewport(0, 0, screenSize[0], screenSize[1]);

                if (fxaa)nvfb.bind();
                else fb1.bind();
                mShader3.bind();
                sdfb.bindtexture(tsxz, 0);
                mShader3.setUniform("u_texture2", 0);
                sdfb2.bindtexture(Vector2i(tsxz[0], bhelper->getlgth() + 4), 1);
                mShader3.setUniform("u_texture1", 1);
                fblg.bindtexture(tsxz, 2);
                mShader3.setUniform("numlgths", bhelper->numlgths);
                mShader3.setUniform("u_texture3", 2);
                mShader3.setUniform("sdwsxd", sdwsxd);
                mShader3.setUniform("fxaa", fxaa);
                mShader3.setUniform("maxlgth", bhelper->maxlgth);
                mShader3.setUniform("u_mouse", umouse);
                mShader3.setUniform("u_time", (float) (float) pto - ptime);
                mShader3.setUniform("playervtime", bhelper->playervtime);
                mShader3.setUniform("plhp", plhp);
                mShader3.setUniform("isdead", isend);
                mShader3.setUniform("playerpos", Vector2f(bhelper->playerpos[0] * bhelper->fposx, bhelper->playerpos[1] * bhelper->fposy));
                mShader3.setUniform("u_resolution", screenSize);
                mShader3.drawIndexed(GL_TRIANGLES, 0, 2);
                if (fxaa) {
                    nvfb.release();
                    nvfb.blittexture();


                    bl1.bind();
                    blaa1.bind();
                    nvfb.bindtexture(tsxz, 0);
                    blaa1.setUniform("u_texture1", 0);
                    blaa1.setUniform("u_resolution", screenSize);
                    blaa1.drawIndexed(GL_TRIANGLES, 0, 2);
                    bl1.release();
                    bl1.blittexture();

                    bl2.bind();
                    blaa2.bind();
                    bl1.bindtexture(tsxz, 0);
                    blaa2.setUniform("u_texture1", 0);
                    blaa2.setUniform("u_resolution", screenSize);
                    blaa2.drawIndexed(GL_TRIANGLES, 0, 2);
                    bl2.release();
                    bl2.blittexture();

                    bl3.bind();
                    blaa3.bind();
                    bl2.bindtexture(tsxz, 0);
                    blaa3.setUniform("u_texture2", 0);
                    nvfb.bindtexture(tsxz, 1);
                    blaa3.setUniform("u_texture1", 1);
                    //blaa3.setUniform("u_time", (float) glfwGetTime());
                    blaa3.setUniform("u_resolution", screenSize);
                    blaa3.drawIndexed(GL_TRIANGLES, 0, 2);
                    bl3.release();
                    bl3.blittexture();

                    fb1.bind();
                    nvfxaa.bind();
                    bl3.bindtexture(tsxz, 0);
                    nvfxaa.setUniform("u_texture1", 0);
                    nvfxaa.setUniform("u_resolution", screenSize);
                    nvfxaa.drawIndexed(GL_TRIANGLES, 0, 2);
                }

                fb1.release();
                fb1.blittexture();
                ahelper->drawonce = false;
            }


            mShader.bind();
            fb1.bindtexture(tsxz, 0);
            mShader.setUniform("u_texture2", 0);
            glActiveTexture(GL_TEXTURE0 + 1);
            glBindTexture(GL_TEXTURE_2D, texturesData[indexfx[0]].first.texture());
            mShader.setUniform("u_texture1", 1);

            mShader.setUniform("u_resolution", screenSize);
            mShader.setUniform("u_time", (float) glfwGetTime());
            Vector4f backgroundclicktimer = Vector4f(glfwGetTime() - ahelper->backgroundclicktimershift[0], glfwGetTime() - ahelper->backgroundclicktimershift[1], glfwGetTime() - ahelper->backgroundclicktimershift[2], glfwGetTime() - ahelper->backgroundclicktimershift[3]);
            mShader.setUniform("backgroundclicktimer", backgroundclicktimer);
            mShader.setUniform("backgroundVisible", (int) ahelper->backgroundVisible);
            mShader.setUniform("backgroundtime", (!ahelper->backgroundAnimstate) ? (float) glfwGetTime() - ahelper->backgroundShifttime : ahelper->fadetime - ((float) glfwGetTime() - ahelper->backgroundShifttime));
            Vector2f tval = Vector2f(ahelper->backgoundClickpos1[0], ahelper->backgoundClickpos1[1]);
            mShader.setUniform("backgoundClickpos1", tval);
            tval = Vector2f(ahelper->backgoundClickpos2[0], ahelper->backgoundClickpos2[1]);
            mShader.setUniform("backgoundClickpos2", tval);
            tval = Vector2f(ahelper->backgoundClickpos3[0], ahelper->backgoundClickpos3[1]);
            mShader.setUniform("backgoundClickpos3", tval);
            tval = Vector2f(ahelper->backgoundClickpos4[0], ahelper->backgoundClickpos4[1]);
            mShader.setUniform("backgoundClickpos4", tval);

            mShader.drawIndexed(GL_TRIANGLES, 0, 2);

        } else {

            //not using VBO
            sdfb.bind();
            clb.bind();
            clb.setUniform("u_resolution", screenSize);
            clb.drawIndexed(GL_TRIANGLES, 0, 2);
            clb.setUniform("playerpos", Vector2f(bhelper->playerpos[0] * bhelper->fposx, bhelper->playerpos[1] * bhelper->fposy));
            //glClearColor(.5, 0., 0., 1.);
            //glClear(GL_COLOR_BUFFER_BIT);
            sdfb.release();
            sdfb.blittexture();
            glEnable(GL_DEPTH_TEST);
            glEnable(GL_BLEND);
            fblg.bind();
            glClearColor(0., 0., 0., 1.);
            glClear(GL_COLOR_BUFFER_BIT);
            fblg.release();
            fblg.blittexture();
            for (int i = 0; i < bhelper->numobj; i++) {
                glViewport(bhelper->posx[i] * bhelper->fposx - 27 * bhelper->fposx,
                        tsxz[1] - bhelper->posy[i] * bhelper->fposy - 27 * bhelper->fposx,
                        54 * bhelper->fposx, 54 * bhelper->fposx);
                sdfb.bind();
                mShader2.bind();
                mShader2.setUniform("u_resolution", screenSize);
                mShader2.setUniform("pos", Vector2f(screenSize[0] - bhelper->posx[i] * bhelper->fposx, screenSize[1] - bhelper->posy[i] * bhelper->fposy));
                mShader2.setUniform("rot", bhelper->rot[i]);
                mShader2.setUniform("viuu", bhelper->typex[i]);
                mShader2.drawIndexed(GL_TRIANGLES, 0, 2);
                sdfb.release();
                sdfb.blittexture();
            }

            for (int i = 0; i < bhelper->numlgths; i++) {
                glViewport(bhelper->lposx[i] * bhelper->fposx - 27 * bhelper->fposx,
                        tsxz[1] - bhelper->lposy[i] * bhelper->fposy - 27 * bhelper->fposx,
                        54 * bhelper->fposx, 54 * bhelper->fposx);
                fblg.bind();
                lgshd.bind();
                lgshd.setUniform("u_resolution", screenSize);
                lgshd.setUniform("ttl", bhelper->ttlx[i]);
                lgshd.setUniform("isspwnr", false);
                lgshd.setUniform("pos", Vector2f(screenSize[0] - bhelper->lposx[i] * bhelper->fposx, screenSize[1] - bhelper->lposy[i] * bhelper->fposy));
                lgshd.setUniform("u_time", (float) (float) glfwGetTime() - ptime + bhelper->idx[i]);
                lgshd.drawIndexed(GL_TRIANGLES, 0, 2);
                fblg.release();
                fblg.blittexture();

            }
            float p = bhelper->sWIDTH / 14;
            glViewport((p + p * bhelper->nxtpos + p / 2.) - 27 * bhelper->fposx,
                    tsxz[1] - (bhelper->sHEIGHT / 8. / 2.) - 27 * bhelper->fposx,
                    54 * bhelper->fposx, 54 * bhelper->fposx);
            fblg.bind();
            lgshd.bind();
            lgshd.setUniform("u_resolution", screenSize);
            float tpx = ((float) glfwGetTime() - ptime - bhelper->lastspwn);
            lgshd.setUniform("ttl", (tpx / (bhelper->gmn)) > 1. ? 1. : (tpx / (bhelper->gmn)));
            lgshd.setUniform("isspwnr", true);

            lgshd.setUniform("pos", Vector2f(screenSize[0] -(p + p * bhelper->nxtpos + p / 2.), screenSize[1] -(bhelper->sHEIGHT / 8. / 2.)));
            lgshd.setUniform("u_time", (float) (float) glfwGetTime() - ptime + bhelper->plrdm);
            lgshd.drawIndexed(GL_TRIANGLES, 0, 2);
            fblg.release();
            fblg.blittexture();



            glDisable(GL_BLEND);
            glDisable(GL_DEPTH_TEST);
            glViewport(0, 0, screenSize[0], bhelper->getlgth() + 4);

            if (sdwsxd) {
                sdfb2.bind();
                sb1.bind();
                sdfb.bindtexture(tsxz, 0);
                sb1.setUniform("u_texture2", 0);
                sb1.setUniform("u_time", (float) (float) glfwGetTime() - ptime);
                //sb1.setUniform("u_mouse", umouse);
                sb1.setUniformFloatArray("lposx", bhelper->lfxposx, bhelper->numlgths);
                sb1.setUniformFloatArray("lposy", bhelper->lfxposy, bhelper->numlgths);
                sb1.setUniformFloatArray("ttlx", bhelper->ttlx, bhelper->numlgths);
                sb1.setUniform("fkres", screenSize);
                sb1.setUniform("numlgths", bhelper->numlgths);
                sb1.setUniform("u_resolution", Vector2f(screenSize[0], bhelper->getlgth() + 4));
                sb1.drawIndexed(GL_TRIANGLES, 0, 2);
                sdfb2.release();
                sdfb2.blittexture();
            }
            glViewport(0, 0, screenSize[0], screenSize[1]);

            if (fxaa)nvfb.bind();
            mShader3.bind();
            sdfb.bindtexture(tsxz, 0);
            mShader3.setUniform("u_texture2", 0);
            //if(sdwsxd) //does not work hm
            {
                sdfb2.bindtexture(Vector2i(tsxz[0], bhelper->getlgth() + 4), 1);
                mShader3.setUniform("u_texture1", 1);
            }
            fblg.bindtexture(tsxz, 2);
            mShader3.setUniform("numlgths", bhelper->numlgths);
            mShader3.setUniform("u_texture3", 2);
            mShader3.setUniform("sdwsxd", sdwsxd);
            mShader3.setUniform("fxaa", fxaa);
            mShader3.setUniform("maxlgth", bhelper->maxlgth);
            mShader3.setUniform("u_mouse", umouse);
            mShader3.setUniform("u_time", (float) glfwGetTime() - ptime);
            mShader3.setUniform("playervtime", bhelper->playervtime);
            mShader3.setUniform("plhp", plhp);
            mShader3.setUniform("isdead", isend);
            mShader3.setUniform("playerpos", Vector2f(bhelper->playerpos[0] * bhelper->fposx, bhelper->playerpos[1] * bhelper->fposy));
            mShader3.setUniform("u_resolution", screenSize);
            mShader3.drawIndexed(GL_TRIANGLES, 0, 2);
            if (fxaa) {
                nvfb.release();
                nvfb.blittexture();

                bl1.bind();
                blaa1.bind();
                nvfb.bindtexture(tsxz, 0);
                blaa1.setUniform("u_texture1", 0);
                blaa1.setUniform("u_resolution", screenSize);
                blaa1.drawIndexed(GL_TRIANGLES, 0, 2);
                bl1.release();
                bl1.blittexture();

                bl2.bind();
                blaa2.bind();
                bl1.bindtexture(tsxz, 0);
                blaa2.setUniform("u_texture1", 0);
                blaa2.setUniform("u_resolution", screenSize);
                blaa2.drawIndexed(GL_TRIANGLES, 0, 2);
                bl2.release();
                bl2.blittexture();

                bl3.bind();
                blaa3.bind();
                bl2.bindtexture(tsxz, 0);
                blaa3.setUniform("u_texture2", 0);
                nvfb.bindtexture(tsxz, 1);
                blaa3.setUniform("u_texture1", 1);
                //blaa3.setUniform("u_time", (float) glfwGetTime());
                blaa3.setUniform("u_resolution", screenSize);
                blaa3.drawIndexed(GL_TRIANGLES, 0, 2);
                bl3.release();
                bl3.blittexture();


                nvfxaa.bind();
                bl3.bindtexture(tsxz, 0);
                nvfxaa.setUniform("u_texture1", 0);
                nvfxaa.setUniform("u_resolution", screenSize);
                nvfxaa.drawIndexed(GL_TRIANGLES, 0, 2);
            }




        }

        resetx = false;

        if (glfwGetTime() - ptime > 3900) {
            if (!paused)resetx = true;
        }
        scrch = (!(((osize - screenSize).norm() == 0)));
        osize = screenSize;

    }
private:
    nanogui::GLShader clb;
    nanogui::GLShader cpshd;
    nanogui::GLShader sb1;
    nanogui::GLShader mShader;
    nanogui::GLShader mShader2;
    nanogui::GLShader mShader3;
    nanogui::GLShader nvfxaa;
    nanogui::GLShader blaa1;
    nanogui::GLShader blaa2;
    nanogui::GLShader blaa3;
    nanogui::GLShader lgshd;
    /*nanogui::GLShader mShader4;
    nanogui::GLShader mShader5;
    nanogui::GLShader mShader6;
    nanogui::GLShader mShader7;
    nanogui::GLShader mShader8;
    nanogui::GLShader mShader9;
    nanogui::GLShader mShader10;
    nanogui::GLShader mShader11;
    nanogui::GLShader mShader12;
    nanogui::GLShader mShader13;
    nanogui::GLShader mShader14;*/
    nanogui::GLFramebuffer fb1;
    nanogui::GLFramebuffer fblg;
    nanogui::GLFramebuffer sdfb;
    nanogui::GLFramebuffer sdfb2;
    nanogui::GLFramebuffer cpfb;
    nanogui::GLFramebuffer nvfb;
    nanogui::GLFramebuffer bl1;
    nanogui::GLFramebuffer bl2;
    nanogui::GLFramebuffer bl3;
    nanogui::GLFramebuffer nvmfb;
    /*nanogui::GLFramebuffer fb2;
    nanogui::GLFramebuffer fb3;
    nanogui::GLFramebuffer fb4;
    nanogui::GLFramebuffer fb5;
    nanogui::GLFramebuffer fb6;
    nanogui::GLFramebuffer fb7;
    nanogui::GLFramebuffer fb8;
    nanogui::GLFramebuffer fb9;
    nanogui::GLFramebuffer fb10;
    nanogui::GLFramebuffer fb11;
    nanogui::GLFramebuffer fb12;
    nanogui::GLFramebuffer fb13;*/
    std::chrono::high_resolution_clock::time_point lastFpsTime;

    void settextures();
    animehelper *ahelper;
    box2dhelper *bhelper;
    void initall();
    void updateallUnioforms();


    using imagesDataType = vector<pair<GLTexture, GLTexture::handleType>>;
    imagesDataType mImagesData;
    imagesDataType texturesData;
    int mCurrentImage;
};

void Ccgm::settextures() {
    using namespace nanogui;
    vector<pair<int, string>> textres = loadImageDirectory(mNVGContext, "textures");
    string resourcesFolderPath("./");
    int i = 0;
    for (auto& texturex : textres) {
        GLTexture texture(texturex.second);
        /*if (texturex.second == ("textures/txt1")) //its fixes for "random non sorted file names in readdir(loadImageDirectory use it)"
            indexfx[1] = i;

        if (texturex.second == ("textures/tx2"))
                    indexfx[1] = i;
                if (texturex.second == ("textures/tx3"))
                    indexfx[2] = i;
                if (texturex.second == ("textures/tx4"))
                    indexfx[3] = i;
                if (texturex.second == ("textures/tx5"))
                    indexfx[4] = i;
                if (texturex.second == ("textures/tx6"))
                    indexfx[5] = i;
                if (texturex.second == ("textures/tx7"))
                    indexfx[6] = i;*/
        if (texturex.second == ("textures/iqn"))
            indexfx[0] = i;
        //bool fmt = texturex.second == ("textures/tx6") || texturex.second == ("textures/tx7");
        auto data = texture.load(resourcesFolderPath + texturex.second + ".png", false, false);
        texturesData.emplace_back(std::move(texture), std::move(data));
        i++;
    }
}

void Ccgm::initall() {

    ahelper = new animehelper();
    bhelper = new box2dhelper();
    bhelper->init();
    emscripten_run_script("generate()");
}

void Ccgm::updateallUnioforms() {
    if (ahelper->backgroundVisible) {
        ahelper->updatebackgroundUniforms((float) glfwGetTime());
    } else {

        bhelper->ticknext();
    }
}

void mainloop() {

    nanogui::mainloop();
}

int main(int /* argc */, char ** /* argv */) {
    try {
        nanogui::init();
        /* scoped variables */
        {
            nanogui::ref<Ccgm> app = new Ccgm();
            app->drawAll();
            app->setVisible(true);
            emscripten_set_main_loop(mainloop, 0, 1);
        }

        nanogui::shutdown();
    } catch (const std::runtime_error &e) {
        std::string error_msg = std::string("Caught a fatal error: ") + std::string(e.what());
#if defined(_WIN32)
        MessageBoxA(nullptr, error_msg.c_str(), NULL, MB_ICONERROR | MB_OK);
#else
        std::cerr << error_msg << endl;
#endif
        return -1;
    }

    return 0;
}
