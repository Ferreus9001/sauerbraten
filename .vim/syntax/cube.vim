" Vim syntax file
" Language:     Cube engine cfg files
" Last Change:  2013-03-07
" Version:      1.337

" TODO $[arg]

" Check if syntax is active {{{1
if exists ("b:current_syntax")
    finish
endif

" Case Sensitive: {{{1
" ===============
syn case match

" Options: {{{1
" ========
setlocal iskeyword=@,48-57,_,192-255,:,#,%,=,<,>,+,-,*,\\|,?,&,/,~,.,!,44,,^
setlocal commentstring=//%s

" Keyword Definition Shortcuts: {{{1
" =============================
" Cube builtin commands like getdemo
command -nargs=* CubeAddCmd         syn keyword cubeCmd         <args> skipwhite nextgroup=cubeParameterRegion
" Cube default defined commands like demo
command -nargs=* CubeAddDefCmd      syn keyword cubeDefCmd      <args> skipwhite nextgroup=cubeAssignmentEquals,cubeParameterRegion
" TODO Cube commands to categorize
command -nargs=* CubeAddDontKnowCmd syn keyword cubeDontKnowCmd <args> skipwhite nextgroup=cubeParameterRegion
command -nargs=* CubeAddShader      syn keyword cubeShader      <args> skipwhite nextgroup=cubeParameterRegion contained
command -nargs=* CubeAddShaderParam syn keyword cubeShaderParam <args> skipwhite nextgroup=cubeParameterRegion contained
" Cube math operation commands like +
command -nargs=* CubeAddMathCmd     syn keyword cubeMathCmd     <args> skipwhite nextgroup=cubeParameterRegion
" Cube by default used variables like gamehud
command -nargs=* CubeAddDefVar      syn keyword cubeDefVar      <args> skipwhite nextgroup=cubeAssignmentEquals,cubeParameterRegion
" Cube builtin variables like maxfps
command -nargs=* CubeAddBuiltinVar  syn keyword cubeBuiltinVar  <args> skipwhite nextgroup=cubeParameterRegion

" Syntax Errors: {{{1
" ==============
syn match cubeBracketError  +\]+ display
syn match cubeParenError    +)+  display
syn match cubeParamError    contained +\s\(\S\&\%(//\)\@!\).*$+

syn cluster cubeError       contains=cubeBracketError,cubeParenError,cubeParamError

" Todo: {{{1
" =====
syn keyword cubeTodo    contained TODO FIXME XXX

" Conditionals: {{{1
" =============
syn keyword cubeConditional if                  skipwhite nextgroup=cubeParameterRegion
syn keyword cubeRepeat      while looplist      skipwhite nextgroup=cubeParameterRegion
" Loop: {{{1
" =====
syn keyword cubeRepeat      loop                   skipwhite nextgroup=cubeLoopVar
syn match cubeLoopVar       contained /@*\<\k\+\>/ skipwhite nextgroup=cubeLoopCount  contains=@cubeParameter
syn match cubeLoopCount     contained /@*\<\k\+\>/ skipwhite nextgroup=@cubeParameter contains=@cubeParameter

" Unknown Commands: {{{1
" =================
syn match   cubeUnknownCmd      /\<\k\+\>/ skipwhite nextgroup=cubeParameterRegion

" Generic Clusters: {{{1
" =================
syn cluster cubeCommands        contains=cubeCmd,cubeAlias,cubeBind,cubeSchemeCmd,cubeDefCmd,cubeDontKnowCmd,cubeMathCmd,cubeBuiltinVar,cubeConditional,cubeRepeat,cubeUnknownCmd,@cubeSchemeCmds,@cubeMacroCommand
" TODO temp commands
"syn cluster cubeCommands        add=cubeShaderParam

syn cluster cubeCommandBlocks   contains=cubeBlock,cubeParen,@cubeMacro
syn cluster cubeBody            contains=@cubeCommands,@cubeCommandBlocks,cubeComment

syn cluster cubeMacro           contains=cubeAtBlock,cubeAtParen,cubeVarParen,cubeAtVariable
syn cluster cubeMacroCommand    contains=cubeAtBlockCommand,cubeAtParenCommand,cubeAtVariableCommand

syn cluster cubeParameter       contains=cubeVariable,cubeNumber,cubeString,cubeUnquotedString,@cubeMacro,@cubeBody

syn cluster cubeSchemeCmds      add=cubeSchemeCmd

syn cluster cubeDelimiters      contains=cubeDelimiter,cubeComment

" Parameter Region: {{{1
" =================
syn region  cubeParameterRegion contained start=+\ze\S\&[^)\];]\&\%(//\)\@!+  end=+[;)\]]+me=s-1 end=+$+ end=+//+me=s-1 keepend contains=@cubeParameter

" Constants: {{{1
" ==========
" string constant without quotes
syn match cubeUnquotedString /\<\k\+\>/                    display contained skipwhite
" number like -543 or 3.14
syn match cubeNumber         /\<[+-]\?\d\+\(\.\d\+\)\?\>/  display contained skipwhite
" number like .05 or -.3
syn match cubeNumber         /\<[+-]\?\.\d\+\>/            display contained skipwhite
" hex-number 0xdeadbeef
syn match cubeNumber         /\<[+-]\?0x\x\+\>/            display contained skipwhite

" Strings: {{{1
" ========
syn region cubeString            start=+"+                                  skip=+\^\^\|\^"+    end=+"+    skipwhite  contains=cubeEscape               extend  display  oneline
" complicated start matches because of possible @-prefixes
syn region cubeBlock             start=+\%([^\$@]\|^\)\@<=\[+               skip=+\^\^\|\^\]+   end=+\]+   skipwhite  contains=TOP,cubeBracketError     extend  fold
syn region cubeParen             start=+\%([^\$@]\|^\)\@<=(+                skip=+\^\^\|\^)+    end=+)+    skipwhite  contains=TOP,cubeParenError       extend
syn region cubeAtBlockCommand    start=+\%([^@]\|^\)\@<=@\+\[+              skip=+\^\^\|\^\]+   end=+\]+   skipwhite  contains=TOP,cubeBracketError     extend  fold  nextgroup=cubeParameterRegion
syn region cubeAtParenCommand    start=+\%([^@]\|^\)\@<=@\+(+               skip=+\^\^\|\^)+    end=+)+    skipwhite  contains=TOP,cubeParenError       extend        nextgroup=cubeParameterRegion
syn region cubeVarParenCommand   start=+\%([^\$]\|^\)\@<=\$\+(+             skip=+\^\^\|\^)+    end=+)+    skipwhite  contains=TOP,cubeParenError       extend        nextgroup=cubeParameterRegion
syn region cubeAtBlock           contained start=+\%([^@]\|^\)\@<=@\+\[+    skip=+\^\^\|\^\]+   end=+\]+   skipwhite  contains=TOP,cubeBracketError,cubeAtBlockCommand    extend  fold
syn region cubeAtParen           contained start=+\%([^@]\|^\)\@<=@\+(+     skip=+\^\^\|\^)+    end=+)+    skipwhite  contains=TOP,cubeParenError,cubeAtParenCommand      extend
syn region cubeVarParen          contained start=+\%([^\$]\|^\)\@<=\$\+(+   skip=+\^\^\|\^)+    end=+)+    skipwhite  contains=TOP,cubeParenError,cubeVarParenCommand     extend

" Entities: {{{1
" =========
syn keyword cubeEntities    contained light playerstart shells bullets rockets riflerounds quaddamage health healthboost
syn keyword cubeEntities    contained greenarmour yellowarmour teleport teledest mapmodel monster trigger jumppad flag
syn keyword cubeEntities    contained spotlight envmap sound base grenades cartridges box barrel platform elevator
syn keyword cubeEntities    contained respawnpoint particles spawn

" Materials: {{{1
" ==========
syn keyword cubeMaterials   contained air water clip glass noclip lava gameclip death alpha

" Shader: {{{1
" =======
CubeAddShader       bumpspecmapworld bumpspecmapparallaxworld stdworld noglareblendworld noglarealphaworld
CubeAddShader       noglareworld depthfxsplitworld depthfxworld fogworld glowworld envworld bumpparallaxworld
CubeAddShader       pulseglowworld bumpspecmapparallaxglowworld bumpspecmapglowworld bumpspecglowworld
CubeAddShader       bumpparallaxglowworld bumpspecparallaxworld bumpenvspecworld decalworld bumpspecworld
CubeAddShader       bumpspecmapparallaxpulseglowworld bumpparallaxpulseglowworld bumpglowworld bumpworld
CubeAddShader       bumpmodel shadowmapcastervertexshader explosionshader shadowmapreceiver

CubeAddShader       bumppulseglowworld bumpspecpulseglowworld bumpspecmappulseglowworld
CubeAddShader       bumpenvworldalt bumpenvworld bumpenvspecmapworld bumpenvglowworldalt bumpenvglowworld
CubeAddShader       bumpenvspecglowworld bumpenvspecmapglowworld bumpenvpulseglowworldalt bumpenvpulseglowworld
CubeAddShader       bumpenvspecmappulseglowworld bumpenvparallaxworldalt bumpenvparallaxworld
CubeAddShader       bumpenvspecparallaxworld bumpenvspecmapparallaxworld bumpenvparallaxglowworldalt
CubeAddShader       bumpenvparallaxglowworld bumpenvspecparallaxglowworld bumpenvspecmapparallaxglowworld
CubeAddShader       bumpenvparallaxpulseglowworldalt bumpenvparallaxpulseglowworld bumpenvspecpulseglowworld
CubeAddShader       bumpenvparallaxpulseglowpulseglowworldalt bumpenvspecparallaxpulseglowworld
CubeAddShader       bumpenvspecmapparallaxpulseglowworld bumpspecparallaxglowworld bumpspecparallaxpulseglowworld
CubeAddShader       envmapnospecmodel masksnospecmodel bumpenvmapnospecmodel bumpmasksnospecmodel
CubeAddShader       nospecmodel masksmodel envmapmodel bumpspecmodel bumpmasksmodel bumpenvmapmodel
CubeAddShader       bumpnospecmodel
CubeAddShader       bloom1 bloom2 bloom3 bloom4 bloom5 bloom6 hblur5 vblur5 hblur3 vblur3 rotoscope
CubeAddShader       waterglare waterglarefast underwaterrefract underwaterrefractfast
CubeAddShader       underwaterfade underwaterfadefast water waterfast waterreflect waterreflectfast
CubeAddShader       waterrefractfast waterfade waterfadefast waterrefract waterenv waterenvfast
CubeAddShader       waterenvrefract waterenvrefractfast waterenvfade waterenvfadefast
CubeAddShader       waterfallenvrefract waterfallrefract
CubeAddShader       glass glassfast
CubeAddShader       caustic causticfast shadowmapcaster notexturemodel

"CubeAddShaderParam  glowcolor specscale parallaxscale pulseglowcolor pulseglowspeed

" Cube Command Keywords: {{{1
" ======================
CubeAddCmd   arch archvertex at attack backward complete concat concatword connect conskip
CubeAddCmd   copy corner delent demodelaymsec demoplaybackspeed demotracking disconnect
CubeAddCmd   dynlight echo editheight edittag edittex edittoggle equalize exec fog
CubeAddCmd   fogcolour format forward fpsrange fullbright gamespeed getmap getmode heighfield
CubeAddCmd   heightfield hidestats history importcube jump kill left lighterror lightscale
CubeAddCmd   listlen loadcrosshair loadgame map mapmodel mapmodelreset mapmsg menuitem clearconsole
CubeAddCmd   minlod mod mode music name newmap newmenu onrelease password paste perlin quit
CubeAddCmd   rate recalc record registersound replace result right rnd savegame savemap say saycommand
CubeAddCmd   scalelights screenshot select sendmap servermenu showmenu showmip showscores skill sleep
CubeAddCmd   slope solid sound stop strcmp team texturereset toggleocull
CubeAddCmd   undo updatefrommaster vdelta waterlevel cleargui weapon setweapon cancelsel clearsleep
CubeAddCmd   gotosel rotateblendbrush paintblendmap entselect minimapcolour
CubeAddCmd   editcopy editpaste passthroughsel redo editface nummonsters trigger
CubeAddCmd   hmapedit showtexgui showentgui showgui notepad mapcfgname gettexname showplayergui
CubeAddCmd   getseltex voffset vrotate vscale entautoview nodebug gridpower
CubeAddCmd   hidehud entselsnap outline wireframe allfaces minimapclip
CubeAddCmd   calclight isspectator do taunt toggleconsole togglemainmenu getaccuracy
CubeAddCmd   getdeaths getfrags indexof cond getflags getname substr strstr strlen max min clearbrush
CubeAddCmd   guifield listclients timeremaining getclientnum nextweapon cycleweapon altsound brushvert
CubeAddCmd   brushx brushy addblendbrush materialreset inputcommand sayteam newgui guibar guibutton 
CubeAddCmd   guilist guiimage getcrosshair guitext isconnected m_edit getteam spectator guistrut
CubeAddCmd   guitab loopfiles guistayopen guiradio getmastermode getclienticon getclientname ismaster
CubeAddCmd   setmaster getclientteam setteam kick guislider guionclear guicheckbox guiservers initservers
CubeAddCmd   guinoautotab guieditor textinit textfocus textload textselectall textsave textpaste textexec
CubeAddCmd   textclear textcopy pastebuffer guitextbox guiplayerpreview guilistslider blendpaintmode
CubeAddCmd   guicolor nummapmodels mapmodelname guimodelpreview guispring vsync fullscreen fsaa colorbits
CubeAddCmd   depthbits stencilbits scr_w scr_h soundfreq soundchans soundbufferlen guilistsplit tabify
CubeAddCmd   guikeyfield guibitfield dropflag enttype entattr guinameslider guititle havesel enthavesel
CubeAddCmd   entcancel entset entget entpaste reorient pastehilite delcube hmapselect selextend pushsel
CubeAddCmd   entpush flip entflip rotate entrotate editmat nextblendbrush getblendbrushname curblendbrush
CubeAddCmd   getcampos getcamyaw getcampitch entcopy guialign strreplace case guicolumn getcamroll
CubeAddCmd   cases isadmin mapname gettotalshots gettotaldamage getmaster m_teammode m_sp m_ctf m_collect
CubeAddCmd   zoom shader defershader variantshader forceshader error addbot delbot listcomplete skybox
CubeAddCmd   loopconcat maptitle prettylist stopdemo setshaderparam setshader autograss mmodel spinsky
CubeAddCmd   loopwhile listdel getmillis push local emitfps flarelights setpostfx screenres getbind
CubeAddCmd   geteditbind getspecbind getweapon getfps loopconcatword casef

CubeAddCmd   savecurrentmap cloudalpha cloudcolour cloudfade fogdomecap fogdomeclip fogdomecolour
CubeAddCmd   fogdomemax fogdomemin skytexture writeobj mapenlarge grassscale grasscolour grassalpha
CubeAddCmd   texscroll texrotate texoffset texscale texalpha valphatexcolor vcolor vreset waterspec
CubeAddCmd   waterfog watercolour waterfallcolour lavafog lavacolour vshaderparam setpixelparam
CubeAddCmd   setvertexparam setuniformparam N mapsound shadowmapambient shadowmapangle causticscale
CubeAddCmd   causticmillis fogdomeheight yawsky cloudbox spinclouds yawclouds cloudclip cloudlayer
CubeAddCmd   cloudscrollx cloudscrolly cloudscale cloudheight ambient edgetolerance sunlight sunlightyaw
CubeAddCmd   sunlightscale skylight lmshadows lmaa patchlight lerpangle lerpsubdiv lerpsubdivsize
CubeAddCmd   lightprecision lightlod blurlms blurskylight dumplms texlayer vlayer setblendbrush
CubeAddCmd   showblendmap clearblendmap clearblendmapsel gettex replacesel savebrush pastebrush hmapcancel
CubeAddCmd   entdrop dropent platform entloop insel et ea showsky optmats entselradius entitysurf
CubeAddCmd   pvs genpvs clearpvs lockpvs testpvs pvsstats showwaypoints dropwaypoints sunlightpitch
CubeAddCmd   loadwaypoints savewaypoints clearwaypoints delselwaypoints selectionsurf skytexturelight
CubeAddCmd   glasscolour glass2colour glass3colour glass4colour

CubeAddCmd   startlistenserver stoplistenserver serverip serverport maxclients serverbotlimit publicserver
CubeAddCmd   serverdesc serverpass adminpass servermotd updatemaster mastername restrictdemos maxdemos
CubeAddCmd   maxdemosize ctftkpenalty ignore unignore lanconnect reconnect clearservers keepserver
CubeAddCmd   damageblendfactor damageblend mastermode clearbans goto pausegame recorddemo
CubeAddCmd   cleardemos listdemos getdemo movie botlimit botbalance
CubeAddCmd   unescape stripcolors getfvarmin getfvarmax getvarmin getvarmax listsplice listfind
CubeAddCmd   sortlist fullconsole importcuberemip isai defvertexparam
CubeAddCmd   dbgdec debugglare dbggras grassanimmillis grassanimscale bumperror lerptjoints
CubeAddCmd   lightcompress adaptivesample lightcachesize patchnormals clearlightmaps fullbrightlevel convertlms
CubeAddCmd   roundlightmaptex batchlightmaps dbgmodes resetgl numcpus mipvis maxmerge
CubeAddCmd   getreptex printvbo vbosize vafacemax vafacemin vacubesize dynentsize phystest
CubeAddCmd   minimizetcusage emlatefog avoidshaders usevp2 usevp3 usetexrect hasglsl useubo usebue usetexcompress
CubeAddCmd   dbgmovie waterfallenvrefract printcube hidegui movieaccelblit movieaccelyuv movierecording
CubeAddCmd   cubecancel gridlookup clearundos delbrush invalidcubeguard usevdelta vscroll valpha getcurtex
CubeAddCmd   renderpath glversion texffenv gendds lightpos lightcolor lightradius
CubeAddCmd   waterpvs genpvs refractsky reloadtex
CubeAddCmd   straferoll faderoll physinterp maxpvsblocker pvsleafsize pvsthreads
CubeAddCmd   rtscissor blurtile dbgexts rtsharefb glext
CubeAddCmd   thirdpersondistance thirdpersonup thirdpersonside
CubeAddCmd   mmodel clearmodel showboundingbox findanims animoverride testanims testpitch
CubeAddCmd   m_noitems m_noammo m_insta m_tactics m_efficiency m_capture m_regencapture m_protect m_hold
CubeAddCmd   m_demo m_lobby m_dmsp m_classicsp servcmd
CubeAddCmd   flipnormalmapy mergenormalmaps isignored insidebases
CubeAddCmd   attachent fixinsidefaces altmapsound resetsound
CubeAddCmd   defpixelparam defuniformparam clearpostfx addpostfx
CubeAddCmd   dauth connectselected isshaderdefined isshadernative shrinkmap
CubeAddCmd   nearestent font fontoffset fontscale fonttex fontchar fontskip fontalias texcolor entindex
CubeAddCmd   hashpwd dauthkick sauthkick mastermodename isauth genauthkey saveauthkeys movewaypoints
CubeAddCmd   adduser clearusers clearwpcache teamkillkick teamkillkickreset maprotationreset getfollow triggerstate checkmaps

CubeAddCmd   mdlcullface mdlcollide mdlellipsecollide mdlspec mdlambient mdlalphatest mdlalphablend mdlalphadepth 
CubeAddCmd   mdldepthoffset mdlglow mdlglare mdlenvmap mdlfullbright mdlshader mdlspin mdlscale mdltrans mdlyaw
CubeAddCmd   mdlpitch mdlshadow mdlbb mdlextendbb mdlname mdlopt stdmodel md2pitch md2anim md5bumpmap md5dir
CubeAddCmd   md5skin md5load md5tag md5spec md5envmap md3load md3skin md5pitch md5adjust md5anim md5glare md5link
CubeAddCmd   objnoclip objcullface md3noclip md3cullface objbumpmap md3bumpmap md3anim md3ambient md5animpart
CubeAddCmd   rdvert rdeye rdtri rdjoint rdlimitdist rdlimitrot rdanimjoints objload objscale objskin objpitch
CubeAddCmd   iqmdir iqmload iqmskin iqmtag iqmanim iqmadjust iqmanimpart iqmpitch md3pitch md3spec objdir objscroll

" Cube Math And Operator Keywords: {{{1
" ===========================
" TODO commands:
CubeAddMathCmd sqrt atan acos asin modf loge log2 log10 minf maxf absf
CubeAddMathCmd ? ! \|\| &&
CubeAddMathCmd & \| ~ &~ << >>
CubeAddMathCmd + - * div +f -f *f divf
CubeAddMathCmd = != < > <= >= =s !=s <s >s <=s >=s =f !=f <f >f <=f >=f

" Cube DontKnowCmds: {{{1
" ==================
"CubeAddDontKnowCmd bumpenvmapnospecmodel bumpenvmapmodel envmapscale maskscale spawnname skin bumpmap adjust pitchcorrect pitchtarget
"CubeAddDontKnowCmd animpart lightdirworld skeleton vertexanimation triangles bumpmasksmodel bumpmasksnospecmodel nodes bumpnospecmodel
"CubeAddDontKnowCmd shadowmapcaster lightdir notexturemodel shadowintensity aidebug
"CubeAddDontKnowCmd explosion2dglare explosion3dglare explosion2dsoft8rect explosion3dsoft8rect explosion2dsoftrect
"CubeAddDontKnowCmd explosion3dsoftrect explosion2dsoft8 explosion3dsoft8 explosion2dsoft explosion3dsoft explosion3d
"CubeAddDontKnowCmd underwater underwaterrefract waterenvrefract noff ffmask ffskip thumbnail colorify colormask premul
"CubeAddDontKnowCmd underwaterfade waterglare waterheight waterenvfade depthfxview particle
"CubeAddDontKnowCmd colorscale particlenotexture lightmap diffusemap glowmap specmap depthmap foggednotextureglsl
"CubeAddDontKnowCmd cleargbans demorecord isif nocompress particlesoft particlesoft8rect particlesoftrect particlesoft8

" Cube Default Command Keywords: {{{1
" ==============================
CubeAddDefCmd  allowspedit demo ffa coop teamplay insta instateam effic efficteam tac tacteam capture
CubeAddDefCmd  regencapture ctf instactf protect instaprotect hold instahold efficctf efficprotect effichold
CubeAddDefCmd  collect instacollect efficcollect sp dmsp editextend editdel editflip selentfindall
CubeAddDefCmd  allowedittoggle selcorners quine loadsky macro delta_game_0 delta_edit_0 delta_edit_1
CubeAddDefCmd  delta_edit_2 delta_edit_3 delta_edit_4 delta_edit_5 delta_edit_6 delta_edit_9 delta_edit_10
CubeAddDefCmd  delta_edit_11 delta_edit_12 delta_edit_13 delta_edit_14 delta_edit_15 delta_edit_16
CubeAddDefCmd  delta_edit_17 delta_edit_18 domodifier universaldelta togglezoom sayteamcommand newbrush
CubeAddDefCmd  editfacewentpush brushhandle brushverts mapcomplete allowedittoggle genmapitems showmapshot showcustommaps
CubeAddDefCmd  startbotmatch showfileeditor notepadfile scratchpad genskyitems showskyshot resetlight
CubeAddDefCmd  lightset lightcmd entupdate initentgui genentattributes newentgui replaceents entfind
CubeAddDefCmd  selreplaceents enttypeselect entreplace entfindinsel lse enttoggle entaddmove drag corners
CubeAddDefCmd  editdrag entadd editmove entdrag editmovewith editmovecorner editmovedrag entdirection entcomplete
CubeAddDefCmd  getsundir minimaphere air clip noclip gameclip death alpha selentedit entproperty
CubeAddDefCmd  water lava glass water1 lava1 glass1 water2 lava2 glass2 water3 lava3 glass3
CubeAddDefCmd  altshader modelshader fastshader watershader blurshader lazyshader bumpshader worldshader
CubeAddDefCmd  glareworldshader bumpvariantshader shadowmapcastervertexshader notexturemodelvertexshader
CubeAddDefCmd  modelvertexshader modelfragmentshader blur3shader blur5shader bloomshader explosionshader
CubeAddDefCmd  particleshader causticshader follow nextfollow searchbinds searchspecbinds searcheditbinds
CubeAddDefCmd  playasong editrotate editcut passthrough setblendpaintmode scrollblendbrush selectbrush
CubeAddDefCmd  setupbloom bloom playermodelbutton

CubeAddDefCmd  ent_action_base ent_action_teleport ent_action_teledest ent_action_mapmodel
CubeAddDefCmd  ent_action_spotlight ent_action_light ent_action_jumppad ent_action_respawnpoint
CubeAddDefCmd  ent_action_playerstart ent_action_envmap ent_action_particles ent_action_sound
CubeAddDefCmd  ent_action_cycle ent_action_shells ent_action_bullets ent_action_rockets
CubeAddDefCmd  ent_action_riflerounds ent_action_grenades ent_action_cartridges ent_action_quaddamage
CubeAddDefCmd  ent_action_health ent_action_healthboost ent_action_greenarmour ent_action_yellowarmour
CubeAddDefCmd  ent_action_box ent_action_barrel ent_action_platform ent_action_elevator

CubeAddDefVar defaultmodifier modifier brushcopy multiplier multiplier2 gamehud guirolloveraction
CubeAddDefVar guirolloverimgaction guirolloverimgpath guirollovername brushindex brushmax brushname
CubeAddDefVar speditlock playermodelnum playermodelname playermodelstory playermodeldir playermodelicon
CubeAddDefVar ffamaps1 ffamaps2 ffamaps3 ffamaps4 ffamaps5 ffamaps6 capturemaps1 capturemaps2 capturemaps3
CubeAddDefVar capturemaps4 ctfmaps1 ctfmaps2 ctfmaps3 ctfmaps4 conceptmaps spmaps allmaps custommaps
CubeAddDefVar crosshairs botmatchcount botmatchmaxskill botmatchminskill newmapsize savemap_name
CubeAddDefVar skies1 skies2 setting_entediting build_trigger lightcolour lightbright bindactions entguitype
CubeAddDefVar entattributes entattribname entattriblimits entattriblimits2 enttypelist entcopybuf
CubeAddDefVar opaquepaste cancelpaste grabbing entswithdirection edithud blendpaintmodes

" Cube Builtin Variable Keywords: {{{1
" ===============================
CubeAddBuiltinVar ammohud animationinterpolationtime muzzlelight muzzleflash floatspeed fullbrightmodels
CubeAddBuiltinVar forceplayermodels teamskins texreduce deadpush aniso applydialog hitsound paused aspect
CubeAddBuiltinVar ati_skybox_bug autoauth autocompactvslots autorepammo autosortservers autoupdateservers
CubeAddBuiltinVar basenumbers bilinear blobdyntris blobfadehigh blobfadelow blobheight blobintensity
CubeAddBuiltinVar blobmargin blobs blobstattris blood blurdepthfx blurdepthfxsigma blurglare blurglaresigma
CubeAddBuiltinVar blurshadowmap blursmsigma bumpmodels bypassheightmapcheck capturetether caustics
CubeAddBuiltinVar chainsawhudgun clockerror clockfix compresspng compresstga confade confilter connectname
CubeAddBuiltinVar connectport conscale consize crosshaircolors crosshairfx crosshairsize cursorsize
CubeAddBuiltinVar damagecompass damagecompassalpha damagecompassfade damagecompassmax damagecompassmin
CubeAddBuiltinVar damagecompasssize damagescreen damagescreenalpha damagescreenfactor damagescreenfade
CubeAddBuiltinVar damagescreenmax damagescreenmin deathscore decalfade decals depthfx depthfxblend
CubeAddBuiltinVar depthfxemuprecision depthfxfilter depthfxfpscale depthfxpartblend depthfxparts depthfxrect
CubeAddBuiltinVar depthfxscale depthfxsize dynlightdist emitmillis explosion2d minimizedynlighttcusage
CubeAddBuiltinVar fewparticles ffdynlights ffshadowmapdist filltjoints flarecutoff flaresize forceplayermodels
CubeAddBuiltinVar fov fpdepthfx fpshadowmap fullbrightmodels fullconfilter fullconsize gamma glare glarescale
CubeAddBuiltinVar glaresize glassenv glowmodels gpuskel grass grassdist grassheight grassstep grasstaper
CubeAddBuiltinVar gui2d guiautotab guiclicktab guifadein guifollow guipushdist guisens hidedead highlightscore
CubeAddBuiltinVar hitcrosshair hitsound hudgun hudgunsdir hudgunsway hwmipmap invmouse thirdperson lightmodels
CubeAddBuiltinVar lightthreads matskel maxbarreldebris maxcon maxdebris maxdecaldistance maxdecaltris menufps 
CubeAddBuiltinVar maxdynlights maxfps maxhistory maxmodelradiusdistance maxparticledistance maxparticles
CubeAddBuiltinVar maxparticletextdistance maxradarscale maxreflect maxroll maxservpings maxsoundradius
CubeAddBuiltinVar maxsoundsatonce maxtexsize maxtrail menuautoclose menudistance miniconfade miniconfilter
CubeAddBuiltinVar miniconsize miniconwidth minimapalpha minimapsize minradarscale motionblur motionblurmillis
CubeAddBuiltinVar motionblurscale mouseaccel movieaccel moviefps movieh movieminquality moviesound moviesync
CubeAddBuiltinVar moview mumble musicvol muzzleflash muzzlelight nompedit oqdynent outlinecolour miniconskip
CubeAddBuiltinVar outlinemeters particleglare particlesize particletext playermodel pvsthreads radarteammates
CubeAddBuiltinVar ragdoll ragdollfade ragdollmillis reducefilter reflectdist reflectmms reflectsize savebak
CubeAddBuiltinVar scoreboard2d screenshotdir screenshotformat searchlan sensitivity sensitivityscale
CubeAddBuiltinVar servpingdecay servpingrate shaderdetail shadowmap shadowmapbias shadowmapdist depthfxprecision
CubeAddBuiltinVar shadowmapintensity shadowmappeelbias shadowmapprecision shadowmapradius shadowmapsize
CubeAddBuiltinVar showclientnum showconnecting showfps showfpsrange showmat showmodeinfo showparticles
CubeAddBuiltinVar showping showpj showservinfo showspectators skyboxglare slowmosp smoothdist smoothmove
CubeAddBuiltinVar soundvol sparklyfix spawnwait teamcolorfrags teamcolortext teamcrosshair teamhudguns
CubeAddBuiltinVar teamskins texcompress texcompressquality texgui2d texguiheight texguitime texguiwidth
CubeAddBuiltinVar texreduce trilinear undomegs usenp2 vertwater wallclock wallclock24 wallclocksecs
CubeAddBuiltinVar waterenvmap waterfade waterfallenv waterfallrefract waterlod waterreflect waterrefract
CubeAddBuiltinVar watersubdiv zoomaccel zoomautosens zoomfov zoominvel zoomoutvel zoomsens stereo
CubeAddBuiltinVar lobbymap lobbymode localmap localmode allplayermodels envmapradius envmapmodels
CubeAddBuiltinVar envmapsize dtoutline ffdlscissor serveruprate masterport dbggrass 
CubeAddBuiltinVar oqdist zpass glowpass envpass batchgeom oqgeom dbgffsm dbgffdl

CubeAddBuiltinVar moving entmoving dragging selectcorners passthroughcube minimapheight entediting shaders
CubeAddBuiltinVar shaderprecision forceglsl killsendsp avatarzoomfov avatarfov avatardepth
CubeAddBuiltinVar nearplane reflectclip reflectclipavatar polygonoffsetfactor polygonoffsetunits
CubeAddBuiltinVar showeditstats statrate animationinterpolationtime ragdolltimestepmin ragdolltimestepmax
CubeAddBuiltinVar ragdollrotfric ragdollrotfricstop ragdollconstrain ragdollwaterexpireoffset ragdollwaterfric
CubeAddBuiltinVar ragdollgroundfric ragdollairfric ragdollunstick ragdollexpireoffset maxskelanimdata
CubeAddBuiltinVar ragdolleyesmooth ragdolleyesmoothmillis ragdollbodyfric aaenvmap depthoffset
CubeAddBuiltinVar lnscrollmillis lnscrollscale lnblendpower debugparticles usedds dbgdds
CubeAddBuiltinVar dbgvars aiforcegun showwaypointsradius water4fog water4spec water4fallcolour
CubeAddBuiltinVar water2spec water2fallcolour water3colour water3fog water3spec water3fallcolour water4colour
CubeAddBuiltinVar lava4fog lava2colour lava2fog lava3colour lava3fog lava4colour dbgsound
CubeAddBuiltinVar shadowmapcasters smdepthpeel smoothshadowmappeel ffsmscissor debugsm
CubeAddBuiltinVar oqfrags oqwait oqmm maxtmus
CubeAddBuiltinVar teamcrosshair paused
CubeAddBuiltinVar lockmaprotation restrictpausegame restrictgamespeed
CubeAddBuiltinVar testquad testarmour testteam testhudgun swaystep swayside swayup scoreboard
CubeAddBuiltinVar attachradius entmovingshadow showentradius entautoviewdist
CubeAddBuiltinVar hwtexsize hwcubetexsize hwmaxaniso
CubeAddBuiltinVar oqwater maskreflect reflectscissor reflectvfc refractclear mapversion octaentsize
CubeAddBuiltinVar defershaders nativeshaders nolights nowater nomasks
CubeAddBuiltinVar cullparticles replayparticles seedparticles dbgpcull dbgpseed depthfxmargin
CubeAddBuiltinVar depthfxbias depthfxscissor debugdepthfx lnjittermillis lnjitterradius lnjitterscale
CubeAddBuiltinVar cloudoffsetx cloudoffsety spincloudlayer yawcloudlayer cloudsubdiv cloudboxalpha
CubeAddBuiltinVar clipsky clampsky fogdomeclouds
CubeAddBuiltinVar reservevpparams maxvpenvparams maxvplocalparams maxfpenvparams maxfplocalparams maxtexcoords
CubeAddBuiltinVar maxvsuniforms maxfsuniforms maxvaryings dbgshader dbgubo reserveshadowmaptc reservedynlighttc
CubeAddBuiltinVar serverauth serverbotbalance

CubeAddBuiltinVar skyboxcolour cloudboxcolour fogdomeclouds water2fog water2colour texcolor blendbrushcolor

CubeAddBuiltinVar getclientmodel hasauthkey
CubeAddBuiltinVar ammohudup ammohuddown ammohudcycle

" Cube Keyboard Keys: {{{1
" ===================
syn case ignore
command -nargs=* CubeAddKey syn keyword cubeKey contained <args> nextgroup=cubeParameterRegion

CubeAddKey MOUSE1 MOUSE2 MOUSE3 MOUSE4 MOUSE5 BACKSPACE TAB CLEAR RETURN PAUSE ESCAPE SPACE EXCLAIM
CubeAddKey QUOTEDBL HASH DOLLAR AMPERSAND QUOTE LEFTPAREN RIGHTPAREN ASTERISK PLUS COMMA MINUS PERIOD
CubeAddKey SLASH 0 1 2 3 4 5 6 7 8 9 COLON SEMICOLON LESS EQUALS GREATER QUESTION AT LEFTBRACKET
CubeAddKey BACKSLASH RIGHTBRACKET CARET UNDERSCORE BACKQUOTE A B C D E F G H I J K L M N O P Q R S
CubeAddKey T U V W X Y Z DELETE KP0 KP1 KP2 KP3 KP4 KP5 KP6 KP7 KP8 KP9 KP_PERIOD KP_DIVIDE KP_MULTIPLY
CubeAddKey KP_MINUS KP_PLUS KP_ENTER KP_EQUALS UP DOWN RIGHT LEFT INSERT HOME END PAGEUP PAGEDOWN
CubeAddKey F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 F13 F14 F15 NUMLOCK CAPSLOCK SCROLLOCK RSHIFT LSHIFT
CubeAddKey RCTRL LCTRL RALT LALT RMETA LMETA LSUPER RSUPER MODE COMPOSE HELP PRINT SYSREQ BREAK MENU
CubeAddKey MOUSE6 MOUSE7 MOUSE8

syn case match

" Level Triggers: TODO (grep maps)
" ===============
"syn match cubeTrigger "level_trigger_[0-9]\+"

" Next Map: {{{1
" =========
" TODO
"syn match cubeNextMap "nextmap_[a-zA-Z0-9_]\+"

" Delta_Game: {{{1

" TODO

" Variables: {{{1
" ==========
syn match cubeVariable          /\$[\$@]\{-}\k\{-}\ze\%(@\|\>\)/        skipwhite contains=cubeAtVariableCommand
syn match cubeAtVariableCommand /@[\$@]\{-}\k\{-}\>/         skipwhite nextgroup=@cubeParameterRegion
"syn match cubeAtVariable    /@\+/                       skipwhite nextgroup=@cubeParameter

syn match cubeAtVariable        contained /@\+\k\+\>/   skipwhite

" Binds: {{{1
" ======
syn keyword cubeBind        bind editbind specbind         skipwhite nextgroup=cubeKey
syn keyword cubeBind        bindvar bindvarquiet           skipwhite nextgroup=cubeKey
syn keyword cubeBind        editbindvar editbindvarquiet   skipwhite nextgroup=cubeKey
syn keyword cubeBind        bindmod editbindmod            skipwhite nextgroup=cubeKey
syn match   cubeBindKey     contained /\<\k\+\>/                     skipwhite nextgroup=@cubeParameter  contains=cubeKey
syn match   cubeBindKey     contained /"\<\k\+\>"/                   skipwhite nextgroup=@cubeParameter  contains=cubeString,cubeKey
syn cluster cubeSchemeCmds  add=cubeBind

" Keymap: {{{1
" =======
syn keyword cubeKeymap      keymap                       skipwhite nextgroup=cubeKeycode
syn match   cubeKeycode     contained /\<[+-]\?\d\+\>/   skipwhite nextgroup=cubeKey     contains=cubeNumber
syn match   cubeKeycode     contained /\<[+-]\?0x\x\+\>/ skipwhite nextgroup=cubeKey     contains=cubeNumber
syn cluster cubeSchemeCmds  add=cubeKeymap

" Alias: {{{1
" ======
syn keyword cubeAlias       alias getalias      skipwhite
syn cluster cubeSchemeCmds  add=cubeAlias

" Texture: {{{1
" ========

syn keyword cubeSchemeCmd     texture                                         skipwhite nextgroup=cubeTextureType
syn match   cubeTextureType   contained /[01cudngsze]/                        skipwhite nextgroup=cubeTexturePath
syn match   cubeTexturePath   contained /\<\k\+\>/                            skipwhite nextgroup=cubeTextureRot
syn region  cubeTexturePath   contained start=+"+  skip=+\^\^\|\^"+  end=+"+  skipwhite nextgroup=cubeTextureRot   keepend extend oneline
syn match   cubeTextureRot    contained /[0-5]/                               skipwhite nextgroup=cubeTexturePosX,@cubeDelimiters   contains=cubeNumber
syn match   cubeTexturePosX   contained /\<\k\+\>/                            skipwhite nextgroup=cubeTexturePosY,@cubeDelimiters   contains=cubeNumber
syn match   cubeTexturePosY   contained /\<\k\+\>/                            skipwhite nextgroup=cubeTextureScale,@cubeDelimiters  contains=cubeNumber
syn match   cubeTextureScale  contained /\<\k\+\>/                            skipwhite nextgroup=cubeParamError,@cubeDelimiters    contains=cubeNumber

" Setshader: {{{1
" ==========

syn keyword cubeSchemeCmd     setshader              skipwhite nextgroup=cubeShaderParam,cubeComment
syn match   cubeShaderParam   contained /\<\k\+\>/   skipwhite nextgroup=@cubeError,cubeComment       contains=cubeShader

" Newent: {{{1
" =======
syn keyword cubeSchemeCmd     newent clearents       skipwhite nextgroup=cubeEntities

" TODO addserver
"syn keyword cubeCmd         addserver           skipwhite  nextgroup=cubeServer
"syn match cubeServer        contained /\<\(\d\{1,3\}\.\)\{3\}\d\{1,3\}\>/   skipwhite nextgroup=@cubeParameter

" Assignments: {{{1
" ============
" TODO add error when more than one parameter after =
syn match  cubeAssignment        +\%(\k\|["\$@]\)\+\ze\s\+=+          skipwhite nextgroup=cubeAssignmentEquals contains=cubeVariable,cubeDefVar,cubeDefCmd,@cubeMacro,cubeString
syn match  cubeAssignmentEquals  +\s\+\zs=+                 contained skipwhite nextgroup=@cubeParameter
"syn region cubeAssignmentRegion contained start=+\ze\S+  end=+\ze[;)\]]+ end=+$+ end=+\ze//+ end=+\ze\s\S+ skipwhite keepend contains=@cubeParameter nextgroup=cubeParamError

" Delimiter: {{{1
" ==========
syn match cubeDelimiter     /;/

" Comments: {{{1
" =========
syn match cubeComment +//.*$+ contains=cubeTodo

" Escapes: {{{1
" ========
syn match cubeEscape        +\^["\^fnt]\?+   extend
" TODO try to get ^L working
"syn match cubeEscape        +\%(\^f\|\)\%(\d\|[\~]\|\a\)+   extend
syn match cubeEscape        +\^f\%(\d\|[\~]\|\a\)+   extend

" Command Shortcut Cleanup: {{{1
" =========================
delcommand CubeAddKey
delcommand CubeAddCmd
delcommand CubeAddDefCmd
delcommand CubeAddDefVar
delcommand CubeAddMathCmd
delcommand CubeAddBuiltinVar
delcommand CubeAddDontKnowCmd
delcommand CubeAddShader
delcommand CubeAddShaderParam

" Synchronization: {{{1
" ================
if !exists("cube_minlines")
  let cube_minlines = 200
endif
if !exists("sh_maxlines")
  let cube_maxlines = 2 * cube_minlines
endif
exec "syn sync minlines=" . cube_minlines . " maxlines=" . cube_maxlines

syn sync match cubeBlockSync    grouphere   cubeBlock  +\%([^@]\|^\)\@<=\[+
syn sync match cubeBlockSync    groupthere  cubeBlock  +\]+
syn sync match cubeParenSync    grouphere   cubeParen  +\%([^@]\|^\)\@<=(+
syn sync match cubeParenSync    groupthere  cubeParen  +)+
syn sync match cubeAtBlockSync  grouphere   cubeAtBlock  +\%([^@]\|^\)\@<=@\+\[+
syn sync match cubeAtBlockSync  groupthere  cubeAtBlock  +\]+
syn sync match cubeAtParenSync  grouphere   cubeAtParen  +\%([^@]\|^\)\@<=@\+(+
syn sync match cubeAtParenSync  groupthere  cubeAtParen  +)+
syn sync match cubeVarParenSync grouphere   cubeVarParen +\%([^\$]\|^\)\@<=\$\+(+
syn sync match cubeVarParenSync groupthere  cubeVarParen +)+
syn sync match cubeAtBlockCommandSync  grouphere   cubeAtBlockCommand  +\%([^@]\|^\)\@<=@\+\[+
syn sync match cubeAtBlockCommandSync  groupthere  cubeAtBlockCommand  +\]+
syn sync match cubeAtParenCommandSync  grouphere   cubeAtParenCommand  +\%([^@]\|^\)\@<=@\+(+
syn sync match cubeAtParenCommandSync  groupthere  cubeAtParenCommand  +)+
syn sync match cubeVarParenCommandSync grouphere   cubeVarParenCommand +\%([^\$]\|^\)\@<=\$\+(+
syn sync match cubeVarParenCommandSync groupthere  cubeVarParenCommand +)+

" Highlighting: {{{1
" =============
"command -nargs=+ HiLink hi link <args>

hi link cubeTodo         Todo
hi link cubeComment      Comment
hi link cubeString       String
hi link cubeTexturePath  String

hi link cubeEscape       Special

hi link cubeVariable     Identifier
hi link cubeTrigger      Identifier
hi link cubeNextMap      Identifier
hi link cubeAssignmentEquals  Identifier

"hi link @cubeError        Error
hi link cubeBracketError Error
hi link cubeParenError   Error
hi link cubeParamError   Error

hi link cubeAtVariable   Special
hi link cubeAtBlock      Special
hi link cubeAtParen      Special
hi link cubeVarParen     Identifier
hi link cubeAtVariableCommand   Special
hi link cubeAtBlockCommand      Special
hi link cubeAtParenCommand      Special
hi link cubeVarParenCommand     Identifier

hi link cubeConditional  Conditional
hi link cubeRepeat       Repeat

hi link cubeBind         Typedef
hi link cubeKeymap       Typedef
hi link cubeAlias        Identifier

hi link cubeSchemeCmd    Statement
hi link cubeTextureType  Statement
hi link cubeCmd          Statement
hi link cubeMathCmd      Statement
hi link cubeDefCmd       Statement
hi link cubeBuiltinVar   Statement
hi link cubeDefVar       Statement

" TODO temp
hi link cubeDontKnowCmd  Title
hi link cubeShader       Title
hi link cubeShaderParam  Title

hi link cubeNumber       Number
hi link cubeServer       Number
hi link cubeDelimiter    Delimiter

hi link cubeEntities     Keyword
hi link cubeKey          Keyword

"delcommand hi link

" Set Current Syntax: {{{1
" ===================
let b:current_syntax = "cube"
" vim:set sw=4 ts=4 sts=0 ft=vim fdm=marker tw=0 et:
