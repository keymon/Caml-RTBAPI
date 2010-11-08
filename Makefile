CAMLC = ocamlc
CAMLOPT = ocamlopt
CAMLDEP = ocamldep
CAMLDOC = ocamldoc

all: rtbapi.cma rtbapi.cmxa

rtbapi.cma: rtbapi.ml rtbapi.cmi
	$(CAMLC) -a $< -o $@ 

rtbapi.cmxa: rtbapi.ml rtbapi.cmi
	$(CAMLOPT) -a $< -o $@ 

%.cmi: %.mli
	$(CAMLC) $< -o $@ 
 
doc-html : rtbapi.cmi
	mkdir html
	$(CAMLDOC) -html -d ./html rtbapi.ml 

depend :  $(OBJS:.cmo=.ml)
	$(CAMLDEP) $(OBJS:.cmo=.ml) *.mli > .depend

clean :
	rm -rf *.cmi *.cmo *.cma *.cmx *.cmxa *.a *.o *% *~ 

# dependencias

ifeq (.depend,$(wildcard .depend))
include .depend
endif
