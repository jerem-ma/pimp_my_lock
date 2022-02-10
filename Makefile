NAME		=	goose

SRCS		=	main.c mlx_utils.c mlx_new_window_fullscreen.c

_OBJS		=	${SRCS:.c=.o}
OBJS		=	$(addprefix build/, $(_OBJS))

CC			=	cc
CFLAGS		=	-Wall -Werror -Wextra -g3
INCLUDE		=	-I includes/ -I libs/minilibx-linux
LIBS		=	libs/minilibx-linux/libmlx.a


#====================Scripts=======================#
define count_files
	TOTAL_FILES=`bash -c 'make -n | grep -- "-c.*-o" | wc -l'`; \
	TOTAL_FILES=$$((TOTAL_FILES-1)); \
	if [ $$TOTAL_FILES -ne 0 ]; then \
		echo -n $$TOTAL_FILES > .MAKEFILE_total_files; \
		echo -n "0" > .MAKEFILE_compiled_files; \
		tput civis; \
	fi;
endef

define file_compiled
	COMPILED=`bash -c 'cat .MAKEFILE_compiled_files'`; \
	COMPILED=$$((COMPILED+1)); \
	echo -n $$COMPILED > .MAKEFILE_compiled_files; \
	sleep 0.1;
endef

define draw_bar
	TOTAL_FILES=`bash -c 'cat .MAKEFILE_total_files'`; \
	COMPILED=`bash -c 'cat .MAKEFILE_compiled_files'`; \
	TOTAL_LENGTH=52; \
	if [ $$COMPILED -eq 0 ]; then \
		COMPLETED_LENGTH=0; \
	else \
		INCREMENT=$$((TOTAL_LENGTH/TOTAL_FILES)); \
		COMPLETED_LENGTH=$$((INCREMENT*COMPILED)); \
	fi; \
	PRINT=0; \
	printf "\r"; \
	while [ $$PRINT -ne $$COMPLETED_LENGTH ]; do \
		printf "\e[0;32m█\e[0m"; \
		PRINT=$$((PRINT+1)); \
	done; \
	if [ $$COMPILED -eq $$TOTAL_FILES ]; then \
		while [ $$PRINT -ne $$TOTAL_LENGTH ]; do \
			printf "\e[0;32m█\e[0m"; \
			PRINT=$$((PRINT+1)); \
		done; \
	fi; \
	while [ $$PRINT -ne $$TOTAL_LENGTH ]; do \
		printf "\e[0m▒\e[0m"; \
		PRINT=$$((PRINT+1)); \
	done; \
	if [ $$COMPILED -eq $$TOTAL_FILES ]; then \
		printf "\n"; \
		tput cvvis; \
	fi;
endef

define clean
	rm -f .MAKEFILE_total_files; \
	rm -f .MAKEFILE_compiled_files; \
	tput cvvis;
endef

BLUE		=	\033[1;34m
CYAN		=	\033[0;36m
GREEN		=	\033[0;32m
ORANGE  	=	\033[0;33m
NO_COLOR	=	\033[m
#==================================================#


all		:	
			@$(call count_files)
			@make -s $(NAME) || $(MAKE) reset

build/%.o	:	srcs/%.c
	@if [ ! -d $(dir $@) ]; then\
		mkdir -p $(dir $@);\
	fi
	@$(call draw_bar)
	@echo "\r$(CYAN)Compiling $(BLUE)$@ ...$(NO_COLOR)                             "
	@$(call draw_bar) 
	@$(CC) ${CFLAGS} ${INCLUDE} -c $< -o $@
	@$(call file_compiled)
			@$(call draw_bar)

$(NAME)	:	$(OBJS) | libs
	@@echo "$(ORANGE)Linking $(BLUE)$@ ...$(NO_COLOR)"
	@$(CC) $(CFLAGS) $(OBJS) $(LIBS) -lXext -lX11 -o $(NAME)
	@$(call clean)
	@echo "$(GREEN)$@ created !$(NO_COLOR)"

libs	:
	@for lib in $(LIBS); do\
		echo make -C $$(dirname $$lib);\
		make -C $$(dirname $$lib);\
	done

clean	:	
	rm -Rf build/

cleanlibs	:
	@for lib in $(LIBS); do\
		echo make -C $$(dirname $$lib) clean;\
		make -C $$(dirname $$lib) clean;\
	done

cleanall	:	clean cleanlibs


fclean	:	clean
	rm -f ${NAME}

fcleanlibs	:
	@for lib in $(LIBS); do\
		echo make -C $$(dirname $$lib) fclean;\
		make -C $$(dirname $$lib) fclean;\
	done

fcleanall	:	fclean fcleanlibs


re		:	fclean 
			@$(call count_files)
			@make -s $(NAME) || $(MAKE) reset

relibs	:

reall	: relibs re

reset:
		@$(call clean)


.PHONY	:	all libs clean cleanlibs cleanall fclean fcleanlibs fcleanall re relibs reall reset
