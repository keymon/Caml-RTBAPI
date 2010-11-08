CAMLC = ocamlc
CAMLDEP = ocamldep
OCAMLINCLUDE = -I ..

LIBS = unix.cma 
RTBAPI = ../rtbapi.cma
ROBOTS = caml_rtbapi_example.robot caml_rtbapi_debug.robot

all: $(ROBOTS)

%.robot: %.cmo $(RTBAPI)
	$(CAMLC) $(OCAMLINCLUDE) -o $@ $(LIBS) $(RTBAPI) $<
	
%.cmo: %.ml
	$(CAMLC) $(OCAMLINCLUDE) -c $< -o $@

$(RTBAPI):
	make -C ..

depend :  $(OBJS:.cmo=.ml)
	$(CAMLDEP) $(OBJS:.cmo=.ml) *.mli > .depend

clean :
	rm -rf $(ROBOTS) *.cmi *.cmo *% *~ 


# dependencias
ifeq (.depend,$(wildcard .depend))
include .depend
endif
