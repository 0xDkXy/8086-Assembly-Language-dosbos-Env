" Vim syntax file
" Language:	TeX
" Maintainer:	Dr. Charles E. Campbell, Jr. <NdrchipO@ScampbellPfamily.AbizM>
" Last Change:	Aug 12, 2010 
" Version:	57
" URL:		http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
"
" Notes: {{{1
"
" 1. If you have a \begin{verbatim} that appears to overrun its boundaries,
"    use %stopzone.
"
" 2. Run-on equations ($..$ and $$..$$, particularly) can also be stopped
"    by suitable use of %stopzone.
"
" 3. If you have a slow computer, you may wish to modify
"
"	syn sync maxlines=200
"	syn sync minlines=50
"
"    to values that are more to your liking.
"
" 4. There is no match-syncing for $...$ and $$...$$; hence large
"    equation blocks constructed that way may exhibit syncing problems.
"    (there's no difference between begin/end patterns)
"
" 5. If you have the variable "g:tex_no_error" defined then none of the
"    lexical error-checking will be done.
"
"    ie. let g:tex_no_error=1

" Version Clears: {{{1
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
scriptencoding utf-8

" Define the default highlighting. {{{1
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tex_syntax_inits")
 let did_tex_syntax_inits = 1
 if version < 508
  command -nargs=+ HiLink hi link <args>
 else
  command -nargs=+ HiLink hi def link <args>
 endif
endif
if exists("g:tex_tex") && !exists("g:tex_no_error")
 let g:tex_no_error= 1
endif

" let user determine which classes of concealment will be supported
"   a=accents/ligatures d=delimiters m=math symbols  g=Greek  s=superscripts/subscripts
if !exists("g:tex_conceal")
 let s:tex_conceal= 'admgs'
else
 let s:tex_conceal= g:tex_conceal
endif

" Determine whether or not to use "*.sty" mode {{{1
" The user may override the normal determination by setting
"   g:tex_stylish to 1      (for    "*.sty" mode)
"    or to           0 else (normal "*.tex" mode)
" or on a buffer-by-buffer basis with b:tex_stylish
let b:extfname=expand("%:e")
if exists("g:tex_stylish")
 let b:tex_stylish= g:tex_stylish
elseif !exists("b:tex_stylish")
 if b:extfname == "sty" || b:extfname == "cls" || b:extfname == "clo" || b:extfname == "dtx" || b:extfname == "ltx"
  let b:tex_stylish= 1
 else
  let b:tex_stylish= 0
 endif
endif

" handle folding {{{1
if !exists("g:tex_fold_enabled")
 let g:tex_fold_enabled= 0
elseif g:tex_fold_enabled && !has("folding")
 let g:tex_fold_enabled= 0
 echomsg "Ignoring g:tex_fold_enabled=".g:tex_fold_enabled."; need to re-compile vim for +fold support"
endif
if g:tex_fold_enabled && &fdm == "manual"
 setl fdm=syntax
endif

" (La)TeX keywords: only use the letters a-zA-Z {{{1
" but _ is the only one that causes problems.
if version < 600
  set isk-=_
  if b:tex_stylish
    set isk+=@
  endif
else
  setlocal isk-=_
  if b:tex_stylish
    setlocal isk+=@
  endif
endif

" Clusters: {{{1
" --------
syn cluster texCmdGroup		contains=texCmdBody,texComment,texDefParm,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texSectionMarker,texSectionName,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle
if !exists("g:tex_no_error")
 syn cluster texCmdGroup	add=texMathError
endif
syn cluster texEnvGroup		contains=texMatcher,texMathDelim,texSpecialChar,texStatement
syn cluster texFoldGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texInputFile,texLength,texLigature,texMatcher,texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ,texNewCmd,texNewEnv,texOnlyMath,texOption,texParen,texRefZone,texSection,texSectionMarker,texSectionZone,texSpaceCode,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,@texMathZones,texTitle,texAbstract
syn cluster texMatchGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcher,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,@Spell
syn cluster texStyleGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texStyleStatement,@Spell,texStyleMatcher
syn cluster texRefGroup		contains=texMatcher,texComment,texDelimiter
if !exists("tex_no_math")
 syn cluster texMathZones	contains=texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ
 syn cluster texMatchGroup	add=@texMathZones
 syn cluster texMathDelimGroup	contains=texMathDelimBad,texMathDelimKey,texMathDelimSet1,texMathDelimSet2
 syn cluster texMathMatchGroup	contains=@texMathZones,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathMatcher,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone
 syn cluster texMathZoneGroup	contains=texComment,texDelimiter,texLength,texMathDelim,texMathMatcher,texMathOper,texMathSymbol,texMathText,texRefZone,texSpecialChar,texStatement,texTypeSize,texTypeStyle
 if !exists("g:tex_no_error")
  syn cluster texMathMatchGroup	add=texMathError
  syn cluster texMathZoneGroup	add=texMathError
 endif
 syn cluster texMathZoneGroup add=@NoSpell
 " following used in the \part \chapter \section \subsection \subsubsection
 " \paragraph \subparagraph \author \title highlighting
 syn cluster texDocGroup		contains=texPartZone,@texPartGroup
 syn cluster texPartGroup		contains=texChapterZone,texSectionZone,texParaZone
 syn cluster texChapterGroup		contains=texSectionZone,texParaZone
 syn cluster texSectionGroup		contains=texSubSectionZone,texParaZone
 syn cluster texSubSectionGroup		contains=texSubSubSectionZone,texParaZone
 syn cluster texSubSubSectionGroup	contains=texParaZone
 syn cluster texParaGroup		contains=texSubParaZone
 if has("conceal") && &enc == 'utf-8'
  syn cluster texMathZoneGroup	add=texGreek,texSuperscript,texSubscript,texMathSymbol
  syn cluster texMathMatchGroup	add=texGreek,texSuperscript,texSubscript,texMathSymbol
 endif
endif

" Try to flag {} and () mismatches: {{{1
if !exists("g:tex_no_error")
 syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texMatchGroup,texError
 syn region texMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texMatchGroup,texError
else
 syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texMatchGroup
 syn region texMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texMatchGroup
endif
syn region texParen		start="("						end=")"		contains=@texMatchGroup,@Spell
if !exists("g:tex_no_error")
 syn match  texError		"[}\])]"
endif
if !exists("tex_no_math")
 if !exists("g:tex_no_error")
  syn match  texMathError	"}"	contained
 endif
 syn region texMathMatcher	matchgroup=Delimiter start="{"  skip="\\\\\|\\}"  end="}" end="%stopzone\>" contained contains=@texMathMatchGroup
endif

" TeX/LaTeX keywords: {{{1
" Instead of trying to be All Knowing, I just match \..alphameric..
" Note that *.tex files may not have "@" in their \commands
if exists("g:tex_tex") || b:tex_stylish
  syn match texStatement	"\\[a-zA-Z@]\+"
else
  syn match texStatement	"\\\a\+"
  if !exists("g:tex_no_error")
   syn match texError		"\\\a*@[a-zA-Z@]*"
  endif
endif

" TeX/LaTeX delimiters: {{{1
syn match texDelimiter		"&"
syn match texDelimiter		"\\\\"

" Tex/Latex Options: {{{1
syn match texOption	"[^\\]\zs#\d\+\|^#\d\+"

" texAccent (tnx to Karim Belabas) avoids annoying highlighting for accents: {{{1
if b:tex_stylish
  syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
else
  syn match texAccent		"\\[bcdvuH]\A"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)\A"me=e-1
endif
syn match texAccent		"\\[bcdvuH]$"
syn match texAccent		+\\[=^.\~"`']+
syn match texAccent		+\\['=t'.c^ud"vb~Hr]{\a}+
syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)$"

" \begin{}/\end{} section markers: {{{1
syn match  texSectionMarker	"\\begin\>\|\\end\>" nextgroup=texSectionName
syn region texSectionName	matchgroup=Delimiter start="{" end="}"  contained	nextgroup=texSectionModifier	contains=texComment
syn region texSectionModifier	matchgroup=Delimiter start="\[" end="]" contained	contains=texComment

" \documentclass, \documentstyle, \usepackage: {{{1
syn match  texDocType		"\\documentclass\>\|\\documentstyle\>\|\\usepackage\>"	nextgroup=texSectionName,texDocTypeArgs
syn region texDocTypeArgs	matchgroup=Delimiter start="\[" end="]"			contained	nextgroup=texSectionName	contains=texComment

" Preamble syntax-based folding support: {{{1
if g:tex_fold_enabled && has("folding")
 syn region texPreamble	transparent fold	start='\zs\\documentclass\>' end='\ze\\begin{document}'	contains=texStyle,@texMatchGroup
endif

" TeX input: {{{1
syn match texInput		"\\input\s\+[a-zA-Z/.0-9_^]\+"hs=s+7				contains=texStatement
syn match texInputFile		"\\include\(graphics\|list\)\=\(\[.\{-}\]\)\=\s*{.\{-}}"	contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputFile		"\\\(epsfig\|input\|usepackage\)\s*\(\[.*\]\)\={.\{-}}"		contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputCurlies	"[{}]"								contained
syn region texInputFileOpt	matchgroup=Delimiter start="\[" end="\]"			contained	contains=texComment

" Type Styles (LaTeX 2.09): {{{1
syn match texTypeStyle		"\\rm\>"
syn match texTypeStyle		"\\em\>"
syn match texTypeStyle		"\\bf\>"
syn match texTypeStyle		"\\it\>"
syn match texTypeStyle		"\\sl\>"
syn match texTypeStyle		"\\sf\>"
syn match texTypeStyle		"\\sc\>"
syn match texTypeStyle		"\\tt\>"

" Type Styles: attributes, commands, families, etc (LaTeX2E): {{{1
syn match texTypeStyle		"\\textbf\>"
syn match texTypeStyle		"\\textit\>"
syn match texTypeStyle		"\\textmd\>"
syn match texTypeStyle		"\\textrm\>"
syn match texTypeStyle		"\\textsc\>"
syn match texTypeStyle		"\\textsf\>"
syn match texTypeStyle		"\\textsl\>"
syn match texTypeStyle		"\\texttt\>"
syn match texTypeStyle		"\\textup\>"
syn match texTypeStyle		"\\emph\>"

syn match texTypeStyle		"\\mathbb\>"
syn match texTypeStyle		"\\mathbf\>"
syn match texTypeStyle		"\\mathcal\>"
syn match texTypeStyle		"\\mathfrak\>"
syn match texTypeStyle		"\\mathit\>"
syn match texTypeStyle		"\\mathnormal\>"
syn match texTypeStyle		"\\mathrm\>"
syn match texTypeStyle		"\\mathsf\>"
syn match texTypeStyle		"\\mathtt\>"

syn match texTypeStyle		"\\rmfamily\>"
syn match texTypeStyle		"\\sffamily\>"
syn match texTypeStyle		"\\ttfamily\>"

syn match texTypeStyle		"\\itshape\>"
syn match texTypeStyle		"\\scshape\>"
syn match texTypeStyle		"\\slshape\>"
syn match texTypeStyle		"\\upshape\>"

syn match texTypeStyle		"\\bfseries\>"
syn match texTypeStyle		"\\mdseries\>"

" Some type sizes: {{{1
syn match texTypeSize		"\\tiny\>"
syn match texTypeSize		"\\scriptsize\>"
syn match texTypeSize		"\\footnotesize\>"
syn match texTypeSize		"\\small\>"
syn match texTypeSize		"\\normalsize\>"
syn match texTypeSize		"\\large\>"
syn match texTypeSize		"\\Large\>"
syn match texTypeSize		"\\LARGE\>"
syn match texTypeSize		"\\huge\>"
syn match texTypeSize		"\\Huge\>"

" Spacecodes (TeX'isms): {{{1
" \mathcode`\^^@="2201  \delcode`\(="028300  \sfcode`\)=0 \uccode`X=`X  \lccode`x=`x
syn match texSpaceCode		"\\\(math\|cat\|del\|lc\|sf\|uc\)code`"me=e-1 nextgroup=texSpaceCodeChar
syn match texSpaceCodeChar    "`\\\=.\(\^.\)\==\(\d\|\"\x\{1,6}\|`.\)"	contained

" Sections, subsections, etc: {{{1
if g:tex_fold_enabled && has("folding")
 syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											fold contains=@texFoldGroup,@texDocGroup,@Spell
 syn region texPartZone			matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								fold contains=@texFoldGroup,@texPartGroup,@Spell
 syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							fold contains=@texFoldGroup,@texChapterGroup,@Spell
 syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					fold contains=@texFoldGroup,@texSectionGroup,@Spell
 syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSectionGroup,@Spell
 syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				fold contains=@texFoldGroup,@texSubSubSectionGroup,@Spell
 syn region texParaZone			matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			fold contains=@texFoldGroup,@texParaGroup,@Spell
 syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	fold contains=@texFoldGroup,@Spell
 syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													fold contains=@texFoldGroup,@Spell
 syn region texAbstract			matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											fold contains=@texFoldGroup,@Spell
else
 syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											contains=@texFoldGroup,@texDocGroup,@Spell
 syn region texPartZone			matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								contains=@texFoldGroup,@texPartGroup,@Spell
 syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							contains=@texFoldGroup,@texChapterGroup,@Spell
 syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					contains=@texFoldGroup,@texSectionGroup,@Spell
 syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSectionGroup,@Spell
 syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSubSectionGroup,@Spell
 syn region texParaZone			matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			contains=@texFoldGroup,@texParaGroup,@Spell
 syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	contains=@texFoldGroup,@Spell
 syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													contains=@texFoldGroup,@Spell
 syn region texAbstract			matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											contains=@texFoldGroup,@Spell
endif

" Bad Math (mismatched): {{{1
if !exists("tex_no_math")
 syn match texBadMath		"\\end\s*{\s*\(array\|gathered\|bBpvV]matrix\|split\|subequations\|smallmatrix\|xxalignat\)\s*}"
 syn match texBadMath		"\\end\s*{\s*\(align\|alignat\|displaymath\|displaymath\|eqnarray\|equation\|flalign\|gather\|math\|multline\|xalignat\)\*\=\s*}"
 syn match texBadMath		"\\[\])]"
endif

" Math Zones: {{{1
if !exists("tex_no_math")
 " TexNewMathZone: function creates a mathzone with the given suffix and mathzone name. {{{2
 "                 Starred forms are created if starform is true.  Starred
 "                 forms have syntax group and synchronization groups with a
 "                 "S" appended.  Handles: cluster, syntax, sync, and HiLink.
 fun! TexNewMathZone(sfx,mathzone,starform)
   let grpname  = "texMathZone".a:sfx
   let syncname = "texSyncMathZone".a:sfx
   if g:tex_fold_enabled
    let foldcmd= " fold"
   else
    let foldcmd= ""
   endif
   exe "syn cluster texMathZones add=".grpname
   exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
   exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
   exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
   exe 'hi def link '.grpname.' texMath'
   if a:starform
    let grpname  = "texMathZone".a:sfx.'S'
    let syncname = "texSyncMathZone".a:sfx.'S'
    exe "syn cluster texMathZones add=".grpname
    exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\*\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\*\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    exe 'hi def link '.grpname.' texMath'
   endif
 endfun

 " Standard Math Zones: {{{2
 call TexNewMathZone("A","align",1)
 call TexNewMathZone("B","alignat",1)
 call TexNewMathZone("C","displaymath",1)
 call TexNewMathZone("D","eqnarray",1)
 call TexNewMathZone("E","equation",1)
 call TexNewMathZone("F","flalign",1)
 call TexNewMathZone("G","gather",1)
 call TexNewMathZone("H","math",1)
 call TexNewMathZone("I","multline",1)
 call TexNewMathZone("J","subequations",0)
 call TexNewMathZone("K","xalignat",1)
 call TexNewMathZone("L","xxalignat",0)

 " Inline Math Zones: {{{2
 if has("conceal") && &enc == 'utf-8' && s:tex_conceal =~ 'd'
  syn region texMathZoneV	matchgroup=Delimiter start="\\("			matchgroup=Delimiter end="\\)\|%stopzone\>"	keepend concealends contains=@texMathZoneGroup
  syn region texMathZoneW	matchgroup=Delimiter start="\\\["			matchgroup=Delimiter end="\\]\|%stopzone\>"	keepend concealends contains=@texMathZoneGroup
  syn region texMathZoneX	matchgroup=Delimiter start="\$" skip="\\\\\|\\\$"	matchgroup=Delimiter end="\$" end="%stopzone\>"		concealends contains=@texMathZoneGroup
  syn region texMathZoneY	matchgroup=Delimiter start="\$\$" 			matchgroup=Delimiter end="\$\$" end="%stopzone\>"	concealends keepend		contains=@texMathZoneGroup
 else
  syn region texMathZoneV	matchgroup=Delimiter start="\\("			matchgroup=Delimiter end="\\)\|%stopzone\>"	keepend contains=@texMathZoneGroup
  syn region texMathZoneW	matchgroup=Delimiter start="\\\["			matchgroup=Delimiter end="\\]\|%stopzone\>"	keepend contains=@texMathZoneGroup
  syn region texMathZoneX	matchgroup=Delimiter start="\$" skip="\\\\\|\\\$"	matchgroup=Delimiter end="\$" end="%stopzone\>"	contains=@texMathZoneGroup
  syn region texMathZoneY	matchgroup=Delimiter start="\$\$" 			matchgroup=Delimiter end="\$\$" end="%stopzone\>"	keepend		contains=@texMathZoneGroup
 endif
 syn region texMathZoneZ	matchgroup=texStatement start="\\ensuremath\s*{"	matchgroup=texStatement end="}" end="%stopzone\>"	contains=@texMathZoneGroup

 syn match texMathOper		"[_^=]" contained

 " Text Inside Math Zones: {{{2
 syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{'	end='}'	contains=@texFoldGroup,@Spell

 " \left..something.. and \right..something.. support: {{{2
 syn match   texMathDelimBad	contained		"\S"
 if has("conceal") && &enc == 'utf-8' && s:tex_conceal =~ 'm'
  syn match   texMathDelim	contained		"\\left\\{\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar={
  syn match   texMathDelim	contained		"\\right\\}\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar=}
 else
  syn match   texMathDelim	contained		"\\\(left\|right\)\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
 endif
 syn match   texMathDelim	contained		"\\\([bB]igg\=[lr]\)\>"			skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
 syn match   texMathDelim	contained		"\\\(left\|right\)arrow\>\|\<\([aA]rrow\|brace\)\=vert\>"
 syn match   texMathDelim	contained		"\\lefteqn\>"
 syn match   texMathDelimSet2	contained	"\\"		nextgroup=texMathDelimKey,texMathDelimBad
 syn match   texMathDelimSet1	contained	"[<>()[\]|/.]\|\\[{}|]"
 syn keyword texMathDelimKey	contained	backslash       lceil           lVert           rgroup          uparrow
 syn keyword texMathDelimKey	contained	downarrow       lfloor          rangle          rmoustache      Uparrow
 syn keyword texMathDelimKey	contained	Downarrow       lgroup          rbrace          rvert           updownarrow
 syn keyword texMathDelimKey	contained	langle          lmoustache      rceil           rVert           Updownarrow
 syn keyword texMathDelimKey	contained	lbrace          lvert           rfloor
endif

" Special TeX characters  ( \$ \& \% \# \{ \} \_ \S \P ) : {{{1
syn match texSpecialChar	"\\[$&%#{}_]"
if b:tex_stylish
  syn match texSpecialChar	"\\[SP@][^a-zA-Z@]"me=e-1
else
  syn match texSpecialChar	"\\[SP@]\A"me=e-1
endif
syn match texSpecialChar	"\\\\"
if !exists("tex_no_math")
 syn match texOnlyMath		"[_^]"
endif
syn match texSpecialChar	"\^\^[0-9a-f]\{2}\|\^\^\S"

" Comments: {{{1
"    Normal TeX LaTeX     :   %....
"    Documented TeX Format:  ^^A...	-and-	leading %s (only)
if !exists("g:tex_comment_nospell") || !g:tex_comment_nospell
 syn cluster texCommentGroup	contains=texTodo,@Spell
else
 syn cluster texCommentGroup	contains=texTodo,@NoSpell
endif
syn case ignore
syn keyword texTodo		contained		combak	fixme	todo	xxx
syn case match
if b:extfname == "dtx"
  syn match texComment		"\^\^A.*$"	contains=@texCommentGroup
  syn match texComment		"^%\+"		contains=@texCommentGroup
else
  if g:tex_fold_enabled
   " allows syntax-folding of 2 or more contiguous comment lines
   " single-line comments are not folded
   syn match  texComment	"%.*$"		contains=@texCommentGroup
   syn region texComment	start="^\zs\s*%.*\_s*%"	skip="^\s*%"	end='^\ze\s*[^%]' fold
  else
   syn match texComment		"%.*$"		contains=@texCommentGroup
  endif
endif

" Separate lines used for verb` and verb# so that the end conditions {{{1
" will appropriately terminate.
" If g:tex_verbspell exists, then verbatim texZones will permit spellchecking there.
if exists("g:tex_verbspell") && g:tex_verbspell
 syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"	contains=@Spell
 " listings package:
 syn region texZone		start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"	contains=@Spell
 " moreverb package:
 syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"	contains=@Spell
 syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"	contains=@Spell
 syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"	contains=@Spell
 if version < 600
  syn region texZone		start="\\verb\*\=`"			end="`\|%stopzone\>"			contains=@Spell
  syn region texZone		start="\\verb\*\=#"			end="#\|%stopzone\>"			contains=@Spell
 else
   if b:tex_stylish
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   else
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   endif
 endif
else
 syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"
 " listings package:
 syn region texZone		start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"
 " moreverb package:
 syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"
 syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"
 syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"
 if version < 600
  syn region texZone		start="\\verb\*\=`"			end="`\|%stopzone\>"
  syn region texZone		start="\\verb\*\=#"			end="#\|%stopzone\>"
 else
   if b:tex_stylish
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"
   else
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"
   endif
 endif
endif

" Tex Reference Zones: {{{1
syn region texZone		matchgroup=texStatement start="@samp{"			end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\nocite{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\bibliography{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\label{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\\(page\|eq\)ref{"	end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\v\=ref{"		end="}\|%stopzone\>"	contains=@texRefGroup
syn match  texRefZone		'\\cite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn region texRefOption	contained	matchgroup=Delimiter start='\[' end=']'		contains=@texRefGroup,texRefZone	nextgroup=texRefOption,texCite
syn region texCite	contained	matchgroup=Delimiter start='{' end='}'		contains=@texRefGroup,texRefZone,texCite

" Handle newcommand, newenvironment : {{{1
syn match  texNewCmd				"\\newcommand\>"			nextgroup=texCmdName skipwhite skipnl
syn region texCmdName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texCmdArgs,texCmdBody skipwhite skipnl
syn region texCmdArgs contained matchgroup=Delimiter start="\["rs=s+1 end="]"		nextgroup=texCmdBody skipwhite skipnl
syn region texCmdBody contained matchgroup=Delimiter start="{"rs=s+1 skip="\\\\\|\\[{}]"	matchgroup=Delimiter end="}" contains=@texCmdGroup
syn match  texNewEnv				"\\newenvironment\>"			nextgroup=texEnvName skipwhite skipnl
syn region texEnvName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvBgn skipwhite skipnl
syn region texEnvBgn  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvEnd skipwhite skipnl contains=@texEnvGroup
syn region texEnvEnd  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		skipwhite skipnl contains=@texEnvGroup

" Definitions/Commands: {{{1
syn match texDefCmd				"\\def\>"				nextgroup=texDefName skipwhite skipnl
if b:tex_stylish
  syn match texDefName contained		"\\[a-zA-Z@]\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\[^a-zA-Z@]"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
else
  syn match texDefName contained		"\\\a\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\\A"					nextgroup=texDefParms,texCmdBody skipwhite skipnl
endif
syn match texDefParms  contained		"#[^{]*"	contains=texDefParm	nextgroup=texCmdBody skipwhite skipnl
syn match  texDefParm  contained		"#\d\+"

" TeX Lengths: {{{1
syn match  texLength		"\<\d\+\([.,]\d\+\)\=\s*\(true\)\=\s*\(bp\|cc\|cm\|dd\|em\|ex\|in\|mm\|pc\|pt\|sp\)\>"

" TeX String Delimiters: {{{1
syn match texString		"\(``\|''\|,,\)"

" makeatletter -- makeatother sections
if !exists("g:tex_no_error")
 syn region texStyle			matchgroup=texStatement start='\\makeatletter' end='\\makeatother'	contains=@texStyleGroup contained
 syn match  texStyleStatement		"\\[a-zA-Z@]\+"	contained
 syn region texStyleMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texStyleGroup,texError	contained
 syn region texStyleMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texStyleGroup,texError	contained
endif

" Conceal mode support (supports set cole=2) {{{1
if has("conceal") && &enc == 'utf-8'

 " Math Symbols {{{2
 " (many of these symbols were contributed by Bj??rn Winckler)
 if s:tex_conceal =~ 'm'
  let s:texMathList=[
    \ ['angle'		, '???'],
    \ ['approx'		, '???'],
    \ ['ast'		, '???'],
    \ ['asymp'		, '???'],
    \ ['backepsilon'	, '???'],
    \ ['backsimeq'	, '???'],
    \ ['barwedge'	, '???'],
    \ ['because'	, '???'],
    \ ['between'	, '???'],
    \ ['bigcap'		, '???'],
    \ ['bigcup'		, '???'],
    \ ['bigodot'	, '???'],
    \ ['bigoplus'	, '???'],
    \ ['bigotimes'	, '???'],
    \ ['bigsqcup'	, '???'],
    \ ['bigtriangledown', '???'],
    \ ['bigvee'		, '???'],
    \ ['bigwedge'	, '???'],
    \ ['blacksquare'	, '???'],
    \ ['bot'		, '???'],
    \ ['boxdot'		, '???'],
    \ ['boxminus'	, '???'],
    \ ['boxplus'	, '???'],
    \ ['boxtimes'	, '???'],
    \ ['bumpeq'		, '???'],
    \ ['Bumpeq'		, '???'],
    \ ['cap'		, '???'],
    \ ['Cap'		, '???'],
    \ ['cdot'		, '??'],
    \ ['cdots'		, '???'],
    \ ['circ'		, '???'],
    \ ['circeq'		, '???'],
    \ ['circlearrowleft', '???'],
    \ ['circlearrowright', '???'],
    \ ['circledast'	, '???'],
    \ ['circledcirc'	, '???'],
    \ ['complement'	, '???'],
    \ ['cong'		, '???'],
    \ ['coprod'		, '???'],
    \ ['cup'		, '???'],
    \ ['Cup'		, '???'],
    \ ['curlyeqprec'	, '???'],
    \ ['curlyeqsucc'	, '???'],
    \ ['curlyvee'	, '???'],
    \ ['curlywedge'	, '???'],
    \ ['dashv'		, '???'],
    \ ['diamond'	, '???'],
    \ ['div'		, '??'],
    \ ['doteq'		, '???'],
    \ ['doteqdot'	, '???'],
    \ ['dotplus'	, '???'],
    \ ['dotsb'		, '???'],
    \ ['dotsc'		, '???'],
    \ ['dots'		, '???'],
    \ ['dotsi'		, '???'],
    \ ['dotso'		, '???'],
    \ ['doublebarwedge'	, '???'],
    \ ['downarrow'	, '???'],
    \ ['Downarrow'	, '???'],
    \ ['emptyset'	, '???'],
    \ ['eqcirc'		, '???'],
    \ ['eqsim'		, '???'],
    \ ['eqslantgtr'	, '???'],
    \ ['eqslantless'	, '???'],
    \ ['equiv'		, '???'],
    \ ['exists'		, '???'],
    \ ['fallingdotseq'	, '???'],
    \ ['forall'		, '???'],
    \ ['ge'		, '???'],
    \ ['geq'		, '???'],
    \ ['geqq'		, '???'],
    \ ['gets'		, '???'],
    \ ['gneqq'		, '???'],
    \ ['gtrdot'		, '???'],
    \ ['gtreqless'	, '???'],
    \ ['gtrless'	, '???'],
    \ ['gtrsim'		, '???'],
    \ ['hookleftarrow'	, '???'],
    \ ['hookrightarrow'	, '???'],
    \ ['iiint'		, '???'],
    \ ['iint'		, '???'],
    \ ['Im'		, '???'],
    \ ['in'		, '???'],
    \ ['infty'		, '???'],
    \ ['int'		, '???'],
    \ ['lceil'		, '???'],
    \ ['ldots'		, '???'],
    \ ['le'		, '???'],
    \ ['leftarrow'	, '???'],
    \ ['Leftarrow'	, '???'],
    \ ['leftarrowtail'	, '???'],
    \ ['left('		, '('],
    \ ['left\['		, '['],
    \ ['left\\{'	, '{'],
    \ ['Leftrightarrow'	, '???'],
    \ ['leftrightsquigarrow', '???'],
    \ ['leftthreetimes'	, '???'],
    \ ['leq'		, '???'],
    \ ['leqq'		, '???'],
    \ ['lessdot'	, '???'],
    \ ['lesseqgtr'	, '???'],
    \ ['lesssim'	, '???'],
    \ ['lfloor'		, '???'],
    \ ['lneqq'		, '???'],
    \ ['ltimes'		, '???'],
    \ ['mapsto'		, '???'],
    \ ['measuredangle'	, '???'],
    \ ['mid'		, '???'],
    \ ['mp'		, '???'],
    \ ['nabla'		, '???'],
    \ ['ncong'		, '???'],
    \ ['nearrow'	, '???'],
    \ ['ne'		, '???'],
    \ ['neg'		, '??'],
    \ ['neq'		, '???'],
    \ ['nexists'	, '???'],
    \ ['ngeq'		, '???'],
    \ ['ngeqq'		, '???'],
    \ ['ngtr'		, '???'],
    \ ['ni'		, '???'],
    \ ['nleftarrow'	, '???'],
    \ ['nLeftarrow'	, '???'],
    \ ['nLeftrightarrow', '???'],
    \ ['nleq'		, '???'],
    \ ['nleqq'		, '???'],
    \ ['nless'		, '???'],
    \ ['nmid'		, '???'],
    \ ['notin'		, '???'],
    \ ['nprec'		, '???'],
    \ ['nrightarrow'	, '???'],
    \ ['nRightarrow'	, '???'],
    \ ['nsim'		, '???'],
    \ ['nsucc'		, '???'],
    \ ['ntriangleleft'	, '???'],
    \ ['ntrianglelefteq', '???'],
    \ ['ntriangleright'	, '???'],
    \ ['ntrianglerighteq', '???'],
    \ ['nvdash'		, '???'],
    \ ['nvDash'		, '???'],
    \ ['nVdash'		, '???'],
    \ ['nwarrow'	, '???'],
    \ ['odot'		, '???'],
    \ ['oint'		, '???'],
    \ ['ominus'		, '???'],
    \ ['oplus'		, '???'],
    \ ['oslash'		, '???'],
    \ ['otimes'		, '???'],
    \ ['owns'		, '???'],
    \ ['partial'	, '???'],
    \ ['perp'		, '???'],
    \ ['pitchfork'	, '???'],
    \ ['pm'		, '??'],
    \ ['precapprox'	, '???'],
    \ ['prec'		, '???'],
    \ ['preccurlyeq'	, '???'],
    \ ['preceq'		, '???'],
    \ ['precnapprox'	, '???'],
    \ ['precneqq'	, '???'],
    \ ['precsim'	, '???'],
    \ ['prod'		, '???'],
    \ ['propto'		, '???'],
    \ ['rceil'		, '???'],
    \ ['Re'		, '???'],
    \ ['rfloor'		, '???'],
    \ ['rightarrow'	, '???'],
    \ ['Rightarrow'	, '???'],
    \ ['rightarrowtail'	, '???'],
    \ ['right)'		, ')'],
    \ ['right]'		, ']'],
    \ ['right\\}'	, '}'],
    \ ['rightsquigarrow', '???'],
    \ ['rightthreetimes', '???'],
    \ ['risingdotseq'	, '???'],
    \ ['rtimes'		, '???'],
    \ ['searrow'	, '???'],
    \ ['setminus'	, '???'],
    \ ['sim'		, '???'],
    \ ['sphericalangle'	, '???'],
    \ ['sqcap'		, '???'],
    \ ['sqcup'		, '???'],
    \ ['sqsubset'	, '???'],
    \ ['sqsubseteq'	, '???'],
    \ ['sqsupset'	, '???'],
    \ ['sqsupseteq'	, '???'],
    \ ['subset'		, '???'],
    \ ['Subset'		, '???'],
    \ ['subseteq'	, '???'],
    \ ['subseteqq'	, '???'],
    \ ['subsetneq'	, '???'],
    \ ['subsetneqq'	, '???'],
    \ ['succapprox'	, '???'],
    \ ['succ'		, '???'],
    \ ['succcurlyeq'	, '???'],
    \ ['succeq'		, '???'],
    \ ['succnapprox'	, '???'],
    \ ['succneqq'	, '???'],
    \ ['succsim'	, '???'],
    \ ['sum'		, '???'],
    \ ['Supset'		, '???'],
    \ ['supseteq'	, '???'],
    \ ['supseteqq'	, '???'],
    \ ['supsetneq'	, '???'],
    \ ['supsetneqq'	, '???'],
    \ ['surd'		, '???'],
    \ ['swarrow'	, '???'],
    \ ['therefore'	, '???'],
    \ ['times'		, '??'],
    \ ['to'		, '???'],
    \ ['top'		, '???'],
    \ ['triangleleft'	, '???'],
    \ ['trianglelefteq'	, '???'],
    \ ['triangleq'	, '???'],
    \ ['triangleright'	, '???'],
    \ ['trianglerighteq', '???'],
    \ ['twoheadleftarrow', '???'],
    \ ['twoheadrightarrow', '???'],
    \ ['uparrow'	, '???'],
    \ ['Uparrow'	, '???'],
    \ ['updownarrow'	, '???'],
    \ ['Updownarrow'	, '???'],
    \ ['varnothing'	, '???'],
    \ ['vartriangle'	, '???'],
    \ ['vdash'		, '???'],
    \ ['vDash'		, '???'],
    \ ['Vdash'		, '???'],
    \ ['vdots'		, '???'],
    \ ['veebar'		, '???'],
    \ ['vee'		, '???'],
    \ ['Vvdash'		, '???'],
    \ ['wedge'		, '???'],
    \ ['wr'		, '???']]
  for texmath in s:texMathList
   exe "syn match texMathSymbol '\\\\".texmath[0]."\\>' contained conceal cchar=".texmath[1]
  endfor

  if &ambw == "double"
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=???
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=???
  else
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=???
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=???
  endif
 endif

 " Greek {{{2
 if s:tex_conceal =~ 'g'
  fun! s:Greek(group,pat,cchar)
    exe 'syn match '.a:group." '".a:pat."' contained conceal cchar=".a:cchar
  endfun
  call s:Greek('texGreek','\\alpha\>'		,'??')
  call s:Greek('texGreek','\\beta\>'		,'??')
  call s:Greek('texGreek','\\gamma\>'		,'??')
  call s:Greek('texGreek','\\delta\>'		,'??')
  call s:Greek('texGreek','\\epsilon\>'		,'??')
  call s:Greek('texGreek','\\varepsilon\>'	,'??')
  call s:Greek('texGreek','\\zeta\>'		,'??')
  call s:Greek('texGreek','\\eta\>'		,'??')
  call s:Greek('texGreek','\\theta\>'		,'??')
  call s:Greek('texGreek','\\vartheta\>'		,'??')
  call s:Greek('texGreek','\\kappa\>'		,'??')
  call s:Greek('texGreek','\\lambda\>'		,'??')
  call s:Greek('texGreek','\\mu\>'		,'??')
  call s:Greek('texGreek','\\nu\>'		,'??')
  call s:Greek('texGreek','\\xi\>'		,'??')
  call s:Greek('texGreek','\\pi\>'		,'??')
  call s:Greek('texGreek','\\varpi\>'		,'??')
  call s:Greek('texGreek','\\rho\>'		,'??')
  call s:Greek('texGreek','\\varrho\>'		,'??')
  call s:Greek('texGreek','\\sigma\>'		,'??')
  call s:Greek('texGreek','\\varsigma\>'		,'??')
  call s:Greek('texGreek','\\tau\>'		,'??')
  call s:Greek('texGreek','\\upsilon\>'		,'??')
  call s:Greek('texGreek','\\phi\>'		,'??')
  call s:Greek('texGreek','\\varphi\>'		,'??')
  call s:Greek('texGreek','\\chi\>'		,'??')
  call s:Greek('texGreek','\\psi\>'		,'??')
  call s:Greek('texGreek','\\omega\>'		,'??')
  call s:Greek('texGreek','\\Gamma\>'		,'??')
  call s:Greek('texGreek','\\Delta\>'		,'??')
  call s:Greek('texGreek','\\Theta\>'		,'??')
  call s:Greek('texGreek','\\Lambda\>'		,'??')
  call s:Greek('texGreek','\\Xi\>'		,'??')
  call s:Greek('texGreek','\\Pi\>'		,'??')
  call s:Greek('texGreek','\\Sigma\>'		,'??')
  call s:Greek('texGreek','\\Upsilon\>'		,'??')
  call s:Greek('texGreek','\\Phi\>'		,'??')
  call s:Greek('texGreek','\\Psi\>'		,'??')
  call s:Greek('texGreek','\\Omega\>'		,'??')
  delfun s:Greek
 endif

 " Superscripts/Subscripts {{{2
 if s:tex_conceal =~ 's'
  syn region texSuperscript	matchgroup=Delimiter start='\^{'	end='}'	contained concealends contains=texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
  syn region texSubscript	matchgroup=Delimiter start='_{'		end='}'	contained concealends contains=texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
  fun! s:SuperSub(group,leader,pat,cchar)
    exe 'syn match '.a:group." '".a:leader.a:pat."' contained conceal cchar=".a:cchar
    exe 'syn match '.a:group."s '".a:pat."' contained conceal cchar=".a:cchar.' nextgroup='.a:group.'s'
  endfun
  call s:SuperSub('texSuperscript','\^','0','???')
  call s:SuperSub('texSuperscript','\^','1','??')
  call s:SuperSub('texSuperscript','\^','2','??')
  call s:SuperSub('texSuperscript','\^','3','??')
  call s:SuperSub('texSuperscript','\^','4','???')
  call s:SuperSub('texSuperscript','\^','5','???')
  call s:SuperSub('texSuperscript','\^','6','???')
  call s:SuperSub('texSuperscript','\^','7','???')
  call s:SuperSub('texSuperscript','\^','8','???')
  call s:SuperSub('texSuperscript','\^','9','???')
  call s:SuperSub('texSuperscript','\^','a','???')
  call s:SuperSub('texSuperscript','\^','b','???')
  call s:SuperSub('texSuperscript','\^','c','???')
  call s:SuperSub('texSuperscript','\^','d','???')
  call s:SuperSub('texSuperscript','\^','e','???')
  call s:SuperSub('texSuperscript','\^','f','???')
  call s:SuperSub('texSuperscript','\^','g','???')
  call s:SuperSub('texSuperscript','\^','h','??')
  call s:SuperSub('texSuperscript','\^','i','???')
  call s:SuperSub('texSuperscript','\^','j','??')
  call s:SuperSub('texSuperscript','\^','k','???')
  call s:SuperSub('texSuperscript','\^','l','??')
  call s:SuperSub('texSuperscript','\^','m','???')
  call s:SuperSub('texSuperscript','\^','n','???')
  call s:SuperSub('texSuperscript','\^','o','???')
  call s:SuperSub('texSuperscript','\^','p','???')
  call s:SuperSub('texSuperscript','\^','r','??')
  call s:SuperSub('texSuperscript','\^','s','??')
  call s:SuperSub('texSuperscript','\^','t','???')
  call s:SuperSub('texSuperscript','\^','u','???')
  call s:SuperSub('texSuperscript','\^','v','???')
  call s:SuperSub('texSuperscript','\^','w','??')
  call s:SuperSub('texSuperscript','\^','x','??')
  call s:SuperSub('texSuperscript','\^','y','??')
  call s:SuperSub('texSuperscript','\^','z','???')
  call s:SuperSub('texSuperscript','\^','A','???')
  call s:SuperSub('texSuperscript','\^','B','???')
  call s:SuperSub('texSuperscript','\^','D','???')
  call s:SuperSub('texSuperscript','\^','E','???')
  call s:SuperSub('texSuperscript','\^','G','???')
  call s:SuperSub('texSuperscript','\^','H','???')
  call s:SuperSub('texSuperscript','\^','I','???')
  call s:SuperSub('texSuperscript','\^','J','???')
  call s:SuperSub('texSuperscript','\^','K','???')
  call s:SuperSub('texSuperscript','\^','L','???')
  call s:SuperSub('texSuperscript','\^','M','???')
  call s:SuperSub('texSuperscript','\^','N','???')
  call s:SuperSub('texSuperscript','\^','O','???')
  call s:SuperSub('texSuperscript','\^','P','???')
  call s:SuperSub('texSuperscript','\^','R','???')
  call s:SuperSub('texSuperscript','\^','T','???')
  call s:SuperSub('texSuperscript','\^','U','???')
  call s:SuperSub('texSuperscript','\^','W','???')
  call s:SuperSub('texSuperscript','\^','+','???')
  call s:SuperSub('texSuperscript','\^','-','???')
  call s:SuperSub('texSuperscript','\^','<','??')
  call s:SuperSub('texSuperscript','\^','>','??')
  call s:SuperSub('texSuperscript','\^','/','??')
  call s:SuperSub('texSuperscript','\^','(','???')
  call s:SuperSub('texSuperscript','\^',')','???')
  call s:SuperSub('texSuperscript','\^','\.','??')
  call s:SuperSub('texSuperscript','\^','=','??')
  call s:SuperSub('texSubscript','_','0','???')
  call s:SuperSub('texSubscript','_','1','???')
  call s:SuperSub('texSubscript','_','2','???')
  call s:SuperSub('texSubscript','_','3','???')
  call s:SuperSub('texSubscript','_','4','???')
  call s:SuperSub('texSubscript','_','5','???')
  call s:SuperSub('texSubscript','_','6','???')
  call s:SuperSub('texSubscript','_','7','???')
  call s:SuperSub('texSubscript','_','8','???')
  call s:SuperSub('texSubscript','_','9','???')
  call s:SuperSub('texSubscript','_','a','???')
  call s:SuperSub('texSubscript','_','e','???')
  call s:SuperSub('texSubscript','_','i','???')
  call s:SuperSub('texSubscript','_','o','???')
  call s:SuperSub('texSubscript','_','u','???')
  call s:SuperSub('texSubscript','_','+','???')
  call s:SuperSub('texSubscript','_','-','???')
  call s:SuperSub('texSubscript','_','/','??')
  call s:SuperSub('texSubscript','_','(','???')
  call s:SuperSub('texSubscript','_',')','???')
  call s:SuperSub('texSubscript','_','\.','???')
  call s:SuperSub('texSubscript','_','r','???')
  call s:SuperSub('texSubscript','_','v','???')
  call s:SuperSub('texSubscript','_','x','???')
  call s:SuperSub('texSubscript','_','\\beta\>' ,'???')
  call s:SuperSub('texSubscript','_','\\delta\>','???')
  call s:SuperSub('texSubscript','_','\\phi\>'  ,'???')
  call s:SuperSub('texSubscript','_','\\gamma\>','???')
  call s:SuperSub('texSubscript','_','\\chi\>'  ,'???')
  delfun s:SuperSub
 endif

 " Accented characters: {{{2
 if s:tex_conceal =~ 'a'
  if b:tex_stylish
   syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
   syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
  else
   fun! s:Accents(chr,...)
     let i= 1
     for accent in ["`","\\'","^",'"','\~','\.',"c","H","k","r","u","v"]
      if i > a:0
       break
      endif
      if strlen(a:{i}) == 0 || a:{i} == ' ' || a:{i} == '?'
       let i= i + 1
       continue
      endif
      if accent =~ '\a'
       exe "syn match texAccent '".'\\'.accent.'\(\s*{'.a:chr.'}\|\s\+'.a:chr.'\)'."' conceal cchar=".a:{i}
      else
       exe "syn match texAccent '".'\\'.accent.'\s*\({'.a:chr.'}\|'.a:chr.'\)'."' conceal cchar=".a:{i}
      endif
      let i= i + 1
     endfor
   endfun
   "                  \`  \'  \^  \"  \~  \.  \c  \H  \k  \r  \u  \v
   call s:Accents('a','??','??','??','??','??',' ',' ',' ','??','??','??','??')
   call s:Accents('A','??','??','??','??','??',' ',' ',' ','??','??','??','??')
   call s:Accents('c',' ','??','??',' ',' ','??','??',' ',' ',' ',' ','??')
   call s:Accents('C',' ','??','??',' ',' ','??','??',' ',' ',' ',' ','??')
   call s:Accents('d',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('D',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('e','??','??','??','??','???','??','??',' ','??',' ','??','??')
   call s:Accents('E','??','??','??','??','???','??','??',' ','??',' ','??','??')
   call s:Accents('g',' ',' ',' ',' ',' ','??','??',' ',' ',' ','??',' ')
   call s:Accents('G',' ',' ',' ',' ',' ','??','??',' ',' ',' ','??',' ')
   call s:Accents('i','??','??','??','??','??','??',' ',' ',' ',' ','??',' ')
   call s:Accents('I','??','??','??','??','??','??',' ',' ',' ',' ','??',' ')
   call s:Accents('l',' ','??','??',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('L',' ','??','??',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('n',' ','??',' ',' ','??',' ','??',' ',' ',' ',' ','??')
   call s:Accents('N',' ','??',' ',' ','??',' ','??',' ',' ',' ',' ','??')
   call s:Accents('o','??','??','??','??','??','??',' ','??','??',' ','??',' ')
   call s:Accents('O','??','??','??','??','??','??',' ','??','??',' ','??',' ')
   call s:Accents('r',' ','??',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('R',' ','??',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('s',' ','??','??',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('S',' ','??','??',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('t',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('T',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('u','??','??','??','??','??',' ',' ','??',' ','??','??',' ')
   call s:Accents('U','??','??','??','??','??',' ',' ','??',' ','??','??',' ')
   call s:Accents('w',' ',' ','??',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('W',' ',' ','??',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('y','???','??','??','??','???',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('Y','???','??','??','??','???',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('z',' ','??',' ',' ',' ','??',' ',' ',' ',' ',' ','??')
   call s:Accents('Z',' ','??',' ',' ',' ','??',' ',' ',' ',' ',' ','??')
   call s:Accents('\\i','??','??','??','??','??','??',' ',' ',' ',' ','??',' ')
   "                  \`  \'  \^  \"  \~  \.  \c  \H  \k  \r  \u  \v
   delfun s:Accents
   syn match texAccent   '\\aa\>'	conceal cchar=??
   syn match texAccent   '\\AA\>'	conceal cchar=??
   syn match texAccent	'\\o\>'		conceal cchar=??
   syn match texAccent	'\\O\>'		conceal cchar=??
   syn match texLigature	'\\AE\>'	conceal cchar=??
   syn match texLigature	'\\ae\>'	conceal cchar=??
   syn match texLigature	'\\oe\>'	conceal cchar=??
   syn match texLigature	'\\OE\>'	conceal cchar=??
   syn match texLigature	'\\ss\>'	conceal cchar=??
  endif
 endif
endif

" ---------------------------------------------------------------------
" LaTeX synchronization: {{{1
syn sync maxlines=200
syn sync minlines=50

syn  sync match texSyncStop			groupthere NONE		"%stopzone\>"

" Synchronization: {{{1
" The $..$ and $$..$$ make for impossible sync patterns
" (one can't tell if a "$$" starts or stops a math zone by itself)
" The following grouptheres coupled with minlines above
" help improve the odds of good syncing.
if !exists("tex_no_math")
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{abstract}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{center}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{description}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{enumerate}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{itemize}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{table}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\end{tabular}"
 syn sync match texSyncMathZoneA		groupthere NONE		"\\\(sub\)*section\>"
endif

" ---------------------------------------------------------------------
" Highlighting: {{{1
if did_tex_syntax_inits == 1
 let did_tex_syntax_inits= 2
  " TeX highlighting groups which should share similar highlighting
  if !exists("g:tex_no_error")
   if !exists("tex_no_math")
    HiLink texBadMath		texError
    HiLink texMathDelimBad	texError
    HiLink texMathError		texError
    if !b:tex_stylish
      HiLink texOnlyMath	texError
    endif
   endif
   HiLink texError		Error
  endif

  HiLink texCite		texRefZone
  HiLink texDefCmd		texDef
  HiLink texDefName		texDef
  HiLink texDocType		texCmdName
  HiLink texDocTypeArgs		texCmdArgs
  HiLink texInputFileOpt	texCmdArgs
  HiLink texInputCurlies	texDelimiter
  HiLink texLigature		texSpecialChar
  if !exists("tex_no_math")
   HiLink texMathDelimSet1	texMathDelim
   HiLink texMathDelimSet2	texMathDelim
   HiLink texMathDelimKey	texMathDelim
   HiLink texMathMatcher	texMath
   HiLink texAccent		texStatement
   HiLink texGreek		texStatement
   HiLink texSuperscript	texStatement
   HiLink texSubscript		texStatement
   HiLink texMathSymbol		texStatement
   HiLink texMathZoneV		texMath
   HiLink texMathZoneW		texMath
   HiLink texMathZoneX		texMath
   HiLink texMathZoneY		texMath
   HiLink texMathZoneV		texMath
   HiLink texMathZoneZ		texMath
  endif
  HiLink texSectionMarker	texCmdName
  HiLink texSectionName		texSection
  HiLink texSpaceCode		texStatement
  HiLink texStyleStatement	texStatement
  HiLink texTypeSize		texType
  HiLink texTypeStyle		texType

   " Basic TeX highlighting groups
  HiLink texCmdArgs		Number
  HiLink texCmdName		Statement
  HiLink texComment		Comment
  HiLink texDef			Statement
  HiLink texDefParm		Special
  HiLink texDelimiter		Delimiter
  HiLink texInput		Special
  HiLink texInputFile		Special
  HiLink texLength		Number
  HiLink texMath		Special
  HiLink texMathDelim		Statement
  HiLink texMathOper		Operator
  HiLink texNewCmd		Statement
  HiLink texNewEnv		Statement
  HiLink texOption		Number
  HiLink texRefZone		Special
  HiLink texSection		PreCondit
  HiLink texSpaceCodeChar	Special
  HiLink texSpecialChar		SpecialChar
  HiLink texStatement		Statement
  HiLink texString		String
  HiLink texTodo		Todo
  HiLink texType		Type
  HiLink texZone		PreCondit

  delcommand HiLink
endif

" Current Syntax: {{{1
unlet b:extfname
let   b:current_syntax = "tex"
" vim: ts=8 fdm=marker
