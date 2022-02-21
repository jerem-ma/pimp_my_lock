NAME		=	goose

SRCS		=	main.c mlx_utils.c mlx_new_window_fullscreen.c farbfeld_to_img.c mlx_new_window_without_border.c play_video.c stop_video.c \
				files.c goose.c gifdec.c

_OBJS		=	${SRCS:.c=.o}
OBJS		=	$(addprefix build/, $(_OBJS))

CC			=	cc
CFLAGS		=	-Wall -Werror -Wextra -g3
INCLUDE		=	-I includes/ -I libs/minilibx-linux -I libs/gifdec
LIBS		=	libs/minilibx-linux/libmlx.a


#====================Scripts=======================#
define count_files
endef

define file_compiled
endef

define draw_bar
endef

define clean
endef

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
	@$(CC) $(CFLAGS) $(OBJS) $(LIBS) -L libs -lXfixes -lXext -lX11 -lvlc -o $(NAME)
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
