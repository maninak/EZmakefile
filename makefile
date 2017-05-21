
##### About #######################################################################################
#                                                                                                 #
# EZmakefile is a plug-n-play, easily configurable, folder-structure-agnostic, makefile           #
# to be consumed by GNU Make tool into C and C++ projects.                                        #
#                                                                                                 #
# EZmakefile makes getting started on new C/C++ projects a breeze and adapts automatically as     #
# your projects get larger. It can be extended to support your custom scenarios if need be, yet   #
# keeps out of your way until then. It features automatic compilation into intermediate object    #
# files, but it does so by compiling only those source files that have been changed since last    #
# build.                                                                                          #
#                                                                                                 #
# The tool is configurable by simply editing the value of variables beginning with '_' found in   #
# the "Configuration" section. Further configuration or extention can be done using the standard  #
# syntax for any makefile of the GNU Make project.                                                #
#                                                                                                 #
# Default make targets are:                                                                       #
# $ make                                                                                          #
# $ make run                                                                                      #
# $ make clean                                                                                    #
#                                                                                                 #
# Author: Kostis Maninakis (maninak)                                                              #
# Licenced under GNU GPLv3 https://www.gnu.org/licenses/gpl-3.0.en.html                           #
#                                                                                                 #
###################################################################################################



#### Configuration ################################################################################

_PROJ   = myEZmadeProject#                     # The name of the project and generated executable
_SDIR   = src#                                 # Path to directory of source files (relative to ./)
_HDIR   = include#                             # Path to directory of header files (relative to ./)
_BDIR   = bin#                                 # Path to directory of binary files (relative to ./)
_SSUF   = cpp#                                 # Suffix of source files
_HSUF   = hpp#                                 # Suffix of header files
_CC     = g++#                                 # Compiler to be used
_CFLAGS = -Wall -Wextra -pedantic#             # Compilation flags
_SCRIPT = :#                                   # Any shell script to run before build (replace ':')

SHELL   = /bin/bash#                           # Shell to be used by makefile
CARGS   = -I $(_HDIR) $(_CFLAGS)#              # Full set of compiler arguments
PURPLE  = \033[0;35m#                          # Encoding of purple color for terminal output
CYAN    = \033[0;36m#                          # Encoding of cyan color for terminal output
NC      = \033[0m#                             # Encoding of no color for terminal output



##### File Lists ##################################################################################

# A list of header files on which source files depend
HEDRS   = $(shell find $(_HDIR) -print | grep .$(_HSUF))

# A list of object files on which their existing source files depend
OBJS    = $(shell find $(_SDIR) -print | grep .$(_SSUF) | \
                  sed -r "s/($(_SDIR))\/(.*)\.($(_SSUF))/$(_BDIR)\/obj\/\2\.o/")



##### Dependency Rules ############################################################################

.PHONY: run clean
.SILENT: $(_BDIR)/$(_PROJ) $(OBJS) $(_BDIR) run clean

# Link all compiled object files
$(_BDIR)/$(_PROJ): $(OBJS)
	$(_CC) -o $@ $^ $(CARGS) && \
	echo -e "EZmakefile: successfully built executable ${CYAN}$@${NC}"

# Compile all outdated source files into their respective object files
$(_BDIR)/obj/%.o: $(_SDIR)/%.$(_SSUF) $(HEDRS) | $(_BDIR)
	echo -e "EZmakefile: compiling source file ${PURPLE}$<${NC}" && \
	$(_CC) -c -o $@ $< $(CARGS)

# Ensure target folders for binaries exist and run any additional user defined shell script
$(_BDIR):
	mkdir -p $(_BDIR)/obj && $(_SCRIPT)

# Run the built executable of your project
run: $(_BDIR)/$(_PROJ)
	echo -e "EZmakefile: launching executable ${CYAN}$(_BDIR)/$(_PROJ)${NC}:" && \
	$(_BDIR)/$(_PROJ)

# Delete all binaries and any editor backups of source and header files
clean:
	echo -e "EZmakefile: cleaning up" && \
	rm -rf $(_BDIR) $(_SDIR)/*~ $(_HDIR)/*~
