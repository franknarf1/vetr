#include "alike.h"

/*
compare types, accounting for "integer like" numerics; empty string means
success, otherwise outputs an a character string explaining why the types are
not alike

call is substituted current, only used when this is called by type_alike directly otherwise doesn't do much
*/
struct ALIKEC_res_fin ALIKEC_type_alike_internal(
  SEXP target, SEXP current, SEXP call, struct VALC_settings set
) {
  SEXPTYPE tar_type, cur_type, tar_type_raw, cur_type_raw;
  int int_like = 0;
  tar_type_raw = TYPEOF(target);
  cur_type_raw = TYPEOF(current);

  struct ALIKEC_res_fin res = (struct ALIKEC_res_fin) {.target="", .actual=""};

  res.call = "";

  if(tar_type_raw == cur_type_raw) return res;

  tar_type = tar_type_raw;
  cur_type = cur_type_raw;

  if(set.type_mode == 0) {
    if(
      tar_type_raw == INTSXP && (
        set.fuzzy_int_max_len < 0 ||
        (
          xlength(target) <= set.fuzzy_int_max_len &&
          xlength(current) <= set.fuzzy_int_max_len
      ) )
    ) {
      int_like = 1;
    }
    if(int_like || (
        tar_type_raw == CLOSXP || tar_type_raw == SPECIALSXP ||
        tar_type_raw == BUILTINSXP
      )
    ) {
      tar_type = ALIKEC_typeof_internal(target);
      cur_type = ALIKEC_typeof_internal(current);
    }
  }
  if(tar_type == cur_type) return res;
  if(
    cur_type == INTSXP && set.type_mode < 2 &&
    (tar_type == INTSXP || tar_type == REALSXP)
  ) {
    return res;
  }
  // This is slow, so we only compute it if we definitely need it (~100us)

  res.call = ALIKEC_pad_or_quote(call, set.width, -1, set);

  const char * what;

  if(set.type_mode == 0 && int_like) {
    what = "integer-like";
  } else if (set.type_mode < 2 && tar_type == REALSXP) {
    what = "numeric";
  } else if (set.type_mode == 0 && tar_type == CLOSXP) {
    what = "function";
  } else {
    what = type2char(tar_type);
  }
  struct ALIKEC_res_fin res_fin;
  res_fin.tar_pre = "be";
  res_fin.target=
    CSR_smprintf4(set.nchar_max, "type \"%s\"", what, "", "", "");
  res_fin.act_pre = "is";
  res_fin.actual = CSR_smprintf4(
    set.nchar_max, "\"%s\"", type2char(cur_type), "", "", ""
  );
  res_fin.call = res.call;
  return res_fin;
}
SEXP ALIKEC_type_alike(
  SEXP target, SEXP current, SEXP call, SEXP settings
) {
  struct ALIKEC_res_fin res;
  struct VALC_settings set = VALC_settings_vet(settings, R_BaseEnv);

  res = ALIKEC_type_alike_internal(target, current, call, set);
  if(res.target[0]) {
    return(ALIKEC_string_or_true(res, set));
  } else {
    return ScalarLogical(1);
  }
}

/* - typeof ----------------------------------------------------------------- */

SEXPTYPE ALIKEC_typeof_internal(SEXP object) {
  double * obj_real;
  SEXPTYPE obj_type = TYPEOF(object);

  switch(obj_type) {
    case REALSXP:
      {
        R_xlen_t obj_len = XLENGTH(object), i;
        obj_real = REAL(object);
        /*
        could optimize this more by using the magic number tricks or bit
        fiddling, but at end of day this still wouldn't be fast enough to
        realistically use on a very large vector, so it doesn't really matter
        */
        for(i = 0; i < obj_len; i++)
          if(!isnan(obj_real[i]) && obj_real[i] != (int)obj_real[i])
            return REALSXP;
        return INTSXP;
      }
      break;
    case CLOSXP:
    case BUILTINSXP:
    case SPECIALSXP:
      return CLOSXP;
  }
  return(obj_type);
}
/*
External interface for typeof, here mostly so we don't have to deal with the
SEXP return in the internal use case
*/

SEXP ALIKEC_typeof(SEXP object) {
  return mkString(type2char(ALIKEC_typeof_internal(object)));
}
