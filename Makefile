NAME		=	pimp_my_lock

SRCS		=	\
				main.c \
				mlx_new_window_without_border.c \
				mlx_utils.c \
				play_video.c \
				stop_video.c

_OBJS		=	${SRCS:.c=.o}
OBJS		=	$(addprefix build/, $(_OBJS))

CC			=	clang
CFLAGS		=	-Wall -Werror -Wextra
INCLUDE		=	-I includes/ -I libs/minilibx-linux
LIBS		=	libs/minilibx-linux/libmlx.a

all		:	$(NAME)

build/%.o	:	srcs/%.c
	@if [ ! -d $(dir $@) ]; then\
		mkdir -p $(dir $@);\
	fi
	@$(CC) ${CFLAGS} ${INCLUDE} -c $< -o $@

$(NAME)	:	$(OBJS) | libs
	$(CC) $(CFLAGS) $(OBJS) $(LIBS) -L libs -lXfixes -lXext -lX11 -lvlc -o $(NAME)

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


.PHONY	:	all libs clean cleanlibs cleanall fclean fcleanlibs fcleanall re relibs reall reset
