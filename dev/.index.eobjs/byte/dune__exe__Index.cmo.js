(function(globalThis)
   {"use strict";
    var
     runtime=globalThis.jsoo_runtime,
     caml_check_bound=runtime.caml_check_bound,
     caml_jsstring_of_string=runtime.caml_jsstring_of_string,
     caml_string_notequal=runtime.caml_string_notequal,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes,
     caml_string_of_jsstring=runtime.caml_string_of_jsstring;
    function caml_call1(f,a0)
     {return f.length == 1?f(a0):runtime.caml_call_gen(f,[a0])}
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    function caml_call3(f,a0,a1,a2)
     {return f.length == 3?f(a0,a1,a2):runtime.caml_call_gen(f,[a0,a1,a2])}
    function caml_call4(f,a0,a1,a2,a3)
     {return f.length == 4
              ?f(a0,a1,a2,a3)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_false=caml_string_of_jsbytes("false"),
     cst_fps=caml_string_of_jsbytes("fps"),
     cst_right=caml_string_of_jsbytes("right"),
     cst_left=caml_string_of_jsbytes("left"),
     cst_down=caml_string_of_jsbytes("down"),
     cst_up=caml_string_of_jsbytes("up"),
     cst_b=caml_string_of_jsbytes("b"),
     cst_a$1=caml_string_of_jsbytes("a"),
     cst_select=caml_string_of_jsbytes("select"),
     cst_start=caml_string_of_jsbytes("start"),
     cst_Enter$0=caml_string_of_jsbytes("Enter"),
     cst_Shift$0=caml_string_of_jsbytes("Shift"),
     cst_a$0=caml_string_of_jsbytes("a"),
     cst_d$0=caml_string_of_jsbytes("d"),
     cst_j$0=caml_string_of_jsbytes("j"),
     cst_k$0=caml_string_of_jsbytes("k"),
     cst_s$0=caml_string_of_jsbytes("s"),
     cst_w$0=caml_string_of_jsbytes("w"),
     cst_Enter=caml_string_of_jsbytes("Enter"),
     cst_Shift=caml_string_of_jsbytes("Shift"),
     cst_a=caml_string_of_jsbytes("a"),
     cst_d=caml_string_of_jsbytes("d"),
     cst_j=caml_string_of_jsbytes("j"),
     cst_k=caml_string_of_jsbytes("k"),
     cst_s=caml_string_of_jsbytes("s"),
     cst_w=caml_string_of_jsbytes("w"),
     rom_options=
      [0,
       [0,
        caml_string_of_jsbytes("The Bouncing Ball"),
        caml_string_of_jsbytes("./the-bouncing-ball.gb")],
       [0,
        [0,
         caml_string_of_jsbytes("Tobu Tobu Girl"),
         caml_string_of_jsbytes("./tobu.gb")],
        [0,
         [0,
          caml_string_of_jsbytes("Cavern"),
          caml_string_of_jsbytes("./cavern.gb")],
         [0,
          [0,
           caml_string_of_jsbytes("Into The Blue"),
           caml_string_of_jsbytes("./into-the-blue.gb")],
          [0,
           [0,
            caml_string_of_jsbytes("Rocket Man Demo"),
            caml_string_of_jsbytes("./rocket-man-demo.gb")],
           [0,
            [0,
             caml_string_of_jsbytes("Retroid"),
             caml_string_of_jsbytes("./retroid.gb")],
            [0,
             [0,
              caml_string_of_jsbytes("Wishing Sarah"),
              caml_string_of_jsbytes("./dreaming-sarah.gb")],
             [0,
              [0,
               caml_string_of_jsbytes("SHEEP IT UP"),
               caml_string_of_jsbytes("./sheep-it-up.gb")],
              0]]]]]]]],
     cst_canvas=caml_string_of_jsbytes("canvas"),
     cst_throttle=caml_string_of_jsbytes("throttle"),
     cst_load_rom=caml_string_of_jsbytes("load-rom"),
     cst_rom_selector=caml_string_of_jsbytes("rom-selector"),
     Brr=global_data.Brr,
     Fut=global_data.Fut,
     Stdlib_List=global_data.Stdlib__List,
     Jv=global_data.Jv,
     Brr_io=global_data.Brr_io,
     Stdlib_Printf=global_data.Stdlib__Printf,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Dune_exe_My_ev=global_data.Dune__exe__My_ev,
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Option=global_data.Stdlib__Option,
     Stdlib_Array=global_data.Stdlib__Array,
     _b_=[0,[8,[0,0,0],0,[0,1],0],caml_string_of_jsbytes("%.1f")],
     _a_=[0,1],
     gb_w=160,
     gb_h=144;
    function find_el_by_id(id)
     {var
       _cN_=caml_jsstring_of_string(id),
       _cO_=Brr[16][2],
       _cP_=Brr[10][2],
       _cQ_=caml_call2(_cP_,_cO_,_cN_);
      return caml_call1(Stdlib_Option[4],_cQ_)}
    function draw_framebuffer(ctx,image_data,fb)
     {var _cx_=Brr_canvas[4][90][4],d=caml_call1(_cx_,image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           _cz_=caml_check_bound(fb,y)[1 + y],
           match=caml_check_bound(_cz_,x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 97;
             var _cA_=off + 1 | 0;
             d[_cA_] = 104;
             var _cB_=off + 2 | 0;
             d[_cB_] = 125;
             var _cC_=off + 3 | 0;
             d[_cC_] = 255}
           else
            {d[off] = 229;
             var _cE_=off + 1 | 0;
             d[_cE_] = 251;
             var _cF_=off + 2 | 0;
             d[_cF_] = 244;
             var _cG_=off + 3 | 0;
             d[_cG_] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             var _cH_=off + 1 | 0;
             d[_cH_] = 174;
             var _cI_=off + 2 | 0;
             d[_cI_] = 184;
             var _cJ_=off + 3 | 0;
             d[_cJ_] = 255}
           else
            {d[off] = 34;
             var _cK_=off + 1 | 0;
             d[_cK_] = 30;
             var _cL_=off + 2 | 0;
             d[_cL_] = 49;
             var _cM_=off + 3 | 0;
             d[_cM_] = 255}
          var _cD_=x + 1 | 0;
          if(159 !== x){var x=_cD_;continue}
          var _cy_=y + 1 | 0;
          if(143 !== y){var y=_cy_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _co_=run_id[1];
      if(_co_)
       {var timer_id=_co_[1],_cp_=Brr[16][10];
        caml_call1(_cp_,timer_id);
        var _cq_=Brr[16][12];
        caml_call1(_cq_,timer_id)}
      var _cr_=key_down_listener[1];
      if(_cr_)
       {var
         lister=_cr_[1],
         _cs_=Brr[16][6],
         _ct_=Brr[7][77],
         _cu_=0,
         _cv_=Brr[7][21];
        caml_call4(_cv_,_cu_,_ct_,lister,_cs_)}
      var _cw_=key_up_listener[1];
      if(_cw_)
       {var lister$0=_cw_[1];
        return caml_call4(Brr[7][21],0,Brr[7][78],lister$0,Brr[16][6])}
      return 0}
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var
           _cm_=Brr[7][31][2],
           _cn_=caml_call1(_cm_,ev),
           key_name=caml_string_of_jsstring(_cn_);
          return caml_string_notequal(key_name,cst_Enter)
                  ?caml_string_notequal(key_name,cst_Shift)
                    ?caml_string_notequal(key_name,cst_a)
                      ?caml_string_notequal(key_name,cst_d)
                        ?caml_string_notequal(key_name,cst_j)
                          ?caml_string_notequal(key_name,cst_k)
                            ?caml_string_notequal(key_name,cst_s)
                              ?caml_string_notequal(key_name,cst_w)?0:caml_call2(C[4],t,1)
                              :caml_call2(C[4],t,0)
                            :caml_call2(C[4],t,7)
                          :caml_call2(C[4],t,6)
                        :caml_call2(C[4],t,3)
                      :caml_call2(C[4],t,2)
                    :caml_call2(C[4],t,5)
                  :caml_call2(C[4],t,4)}
        function key_up_listener(ev)
         {var
           _ck_=Brr[7][31][2],
           _cl_=caml_call1(_ck_,ev),
           key_name=caml_string_of_jsstring(_cl_);
          return caml_string_notequal(key_name,cst_Enter$0)
                  ?caml_string_notequal(key_name,cst_Shift$0)
                    ?caml_string_notequal(key_name,cst_a$0)
                      ?caml_string_notequal(key_name,cst_d$0)
                        ?caml_string_notequal(key_name,cst_j$0)
                          ?caml_string_notequal(key_name,cst_k$0)
                            ?caml_string_notequal(key_name,cst_s$0)
                              ?caml_string_notequal(key_name,cst_w$0)
                                ?0
                                :caml_call2(C[5],t,1)
                              :caml_call2(C[5],t,0)
                            :caml_call2(C[5],t,7)
                          :caml_call2(C[5],t,6)
                        :caml_call2(C[5],t,3)
                      :caml_call2(C[5],t,2)
                    :caml_call2(C[5],t,5)
                  :caml_call2(C[5],t,4)}
        var _cc_=Brr[16][6],_cd_=Brr[7][77],_ce_=0,_cf_=Brr[7][20];
        caml_call4(_cf_,_ce_,_cd_,key_down_listener,_cc_);
        var _cg_=Brr[16][6],_ch_=Brr[7][78],_ci_=0,_cj_=Brr[7][20];
        caml_call4(_cj_,_ci_,_ch_,key_up_listener,_cg_);
        return set_listener(key_down_listener,key_up_listener)}}
    function set_up_joypad(C)
     {return function(t)
       {var
         right_el=find_el_by_id(cst_right),
         left_el=find_el_by_id(cst_left),
         down_el=find_el_by_id(cst_down),
         up_el=find_el_by_id(cst_up),
         b_el=find_el_by_id(cst_b),
         a_el=find_el_by_id(cst_a$1),
         select_el=find_el_by_id(cst_select),
         start_el=find_el_by_id(cst_start);
        function viberate(ms)
         {var navigator=Brr[16][3];navigator.vibrate(ms);return 0}
        function press(ev,t,key)
         {var _ca_=Brr[7][13];
          caml_call1(_ca_,ev);
          var _cb_=10;
          viberate(_cb_);
          return caml_call2(C[4],t,key)}
        function release(ev,t,key)
         {var _b$_=Brr[7][13];
          caml_call1(_b$_,ev);
          return caml_call2(C[5],t,key)}
        var
         _a__=0,
         _a$_=0,
         _ba_=0,
         _bb_=Brr[7][19],
         listen_ops=caml_call4(_bb_,_a_,_ba_,_a$_,_a__);
        function _bc_(ev){return press(ev,t,1)}
        var _bd_=Dune_exe_My_ev[2],_be_=[0,listen_ops],_bf_=Brr[7][20];
        caml_call4(_bf_,_be_,_bd_,_bc_,up_el);
        function _bg_(ev){return press(ev,t,0)}
        var _bh_=Dune_exe_My_ev[2],_bi_=[0,listen_ops],_bj_=Brr[7][20];
        caml_call4(_bj_,_bi_,_bh_,_bg_,down_el);
        function _bk_(ev){return press(ev,t,2)}
        var _bl_=Dune_exe_My_ev[2],_bm_=[0,listen_ops],_bn_=Brr[7][20];
        caml_call4(_bn_,_bm_,_bl_,_bk_,left_el);
        function _bo_(ev){return press(ev,t,3)}
        var _bp_=Dune_exe_My_ev[2],_bq_=[0,listen_ops],_br_=Brr[7][20];
        caml_call4(_br_,_bq_,_bp_,_bo_,right_el);
        function _bs_(ev){return press(ev,t,7)}
        var _bt_=Dune_exe_My_ev[2],_bu_=[0,listen_ops],_bv_=Brr[7][20];
        caml_call4(_bv_,_bu_,_bt_,_bs_,a_el);
        function _bw_(ev){return press(ev,t,6)}
        var _bx_=Dune_exe_My_ev[2],_by_=[0,listen_ops],_bz_=Brr[7][20];
        caml_call4(_bz_,_by_,_bx_,_bw_,b_el);
        function _bA_(ev){return press(ev,t,4)}
        var _bB_=Dune_exe_My_ev[2],_bC_=[0,listen_ops],_bD_=Brr[7][20];
        caml_call4(_bD_,_bC_,_bB_,_bA_,start_el);
        function _bE_(ev){return press(ev,t,5)}
        var _bF_=Dune_exe_My_ev[2],_bG_=[0,listen_ops],_bH_=Brr[7][20];
        caml_call4(_bH_,_bG_,_bF_,_bE_,select_el);
        function _bI_(ev){return release(ev,t,1)}
        var _bJ_=Dune_exe_My_ev[3],_bK_=[0,listen_ops],_bL_=Brr[7][20];
        caml_call4(_bL_,_bK_,_bJ_,_bI_,up_el);
        function _bM_(ev){return release(ev,t,0)}
        var _bN_=Dune_exe_My_ev[3],_bO_=[0,listen_ops],_bP_=Brr[7][20];
        caml_call4(_bP_,_bO_,_bN_,_bM_,down_el);
        function _bQ_(ev){return release(ev,t,2)}
        var _bR_=Dune_exe_My_ev[3],_bS_=[0,listen_ops],_bT_=Brr[7][20];
        caml_call4(_bT_,_bS_,_bR_,_bQ_,left_el);
        function _bU_(ev){return release(ev,t,3)}
        var _bV_=Dune_exe_My_ev[3],_bW_=[0,listen_ops],_bX_=Brr[7][20];
        caml_call4(_bX_,_bW_,_bV_,_bU_,right_el);
        function _bY_(ev){return release(ev,t,7)}
        var _bZ_=Dune_exe_My_ev[3],_b0_=[0,listen_ops],_b1_=Brr[7][20];
        caml_call4(_b1_,_b0_,_bZ_,_bY_,a_el);
        function _b2_(ev){return release(ev,t,6)}
        var _b3_=Dune_exe_My_ev[3],_b4_=[0,listen_ops],_b5_=Brr[7][20];
        caml_call4(_b5_,_b4_,_b3_,_b2_,b_el);
        function _b6_(ev){return release(ev,t,4)}
        var _b7_=Dune_exe_My_ev[3],_b8_=[0,listen_ops],_b9_=Brr[7][20];
        caml_call4(_b9_,_b8_,_b7_,_b6_,start_el);
        function _b__(ev){return release(ev,t,5)}
        return caml_call4
                (Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_b__,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {var _aP_=0;
      clear(_aP_);
      var
       _aQ_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_aQ_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _aR_=1,
       _aS_=C[2],
       t=caml_call2(_aS_,_aR_,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var
       cnt=[0,0],
       _aT_=Brr[16][4],
       _aU_=Brr[15][9],
       start_time=[0,caml_call1(_aU_,_aT_)];
      function set_fps(fps)
       {var
         _a4_=Stdlib_Printf[4],
         fps_str=caml_call2(_a4_,_b_,fps),
         fps_el=find_el_by_id(cst_fps),
         _a5_=0,
         _a6_=caml_jsstring_of_string(fps_str),
         _a7_=0,
         _a8_=Brr[9][2],
         _a9_=[0,caml_call2(_a8_,_a7_,_a6_),_a5_];
        return caml_call2(Brr[9][18],fps_el,_a9_)}
      function main_loop(param)
       {for(;;)
         {var _aV_=C[3],match=caml_call1(_aV_,t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               _aW_=Brr[16][4],
               _aX_=Brr[15][9],
               end_time=caml_call1(_aX_,_aW_),
               _aY_=start_time[1],
               _aZ_=end_time - _aY_,
               sec_per_60_frame=_aZ_ / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              set_fps(fps);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var _a0_=function(param){return main_loop(0)},_a1_=Brr[16][11];
              run_id[1] = [0,caml_call1(_a1_,_a0_)];
              return 0}
            var _a2_=0,_a3_=Brr[16][8];
            run_id[1] = [0,caml_call2(_a3_,_a2_,main_loop)];
            return 0}
          continue}}
      return main_loop(0)}
    function run_rom_blob(ctx,image_data,rom_blob)
     {function _aB_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _aE_=0,
           _aF_=0,
           _aG_=3,
           _aH_=Brr[1][5],
           _aI_=caml_call4(_aH_,_aG_,_aF_,_aE_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_aI_),
           _aJ_=run_rom_bytes(ctx,image_data,rom_bytes);
          return caml_call1(Fut[3],_aJ_)}
        var
         e=result[1],
         _aK_=0,
         _aL_=Jv[30][4],
         _aM_=[0,caml_call1(_aL_,e),_aK_],
         _aN_=Brr[12][9],
         _aO_=caml_call1(_aN_,_aM_);
        return caml_call1(Fut[3],_aO_)}
      var _aC_=Brr[2][8],_aD_=caml_call1(_aC_,rom_blob);
      return caml_call2(Fut[15][1],_aD_,_aB_)}
    function on_load_rom(ctx,image_data,input_el)
     {var
       _aw_=Brr[9][59][1],
       _ax_=caml_call1(_aw_,input_el),
       _ay_=Stdlib_List[5],
       file=caml_call1(_ay_,_ax_);
      function _az_(param){return 0}
      var _aA_=run_rom_blob(ctx,image_data,file);
      return caml_call2(Fut[2],_aA_,_az_)}
    function run_selected_rom(ctx,image_data,rom_path)
     {function _ae_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _aj_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(ctx,image_data,blob)}
              var
               e=result[1],
               _ar_=0,
               _as_=Jv[30][4],
               _at_=[0,caml_call1(_as_,e),_ar_],
               _au_=Brr[12][9],
               _av_=caml_call1(_au_,_at_);
              return caml_call1(Fut[3],_av_)},
           _ak_=Brr_io[3][1][9],
           _al_=caml_call1(_ak_,response);
          return caml_call2(Fut[15][1],_al_,_aj_)}
        var
         e=result[1],
         _am_=0,
         _an_=Jv[30][4],
         _ao_=[0,caml_call1(_an_,e),_am_],
         _ap_=Brr[12][9],
         _aq_=caml_call1(_ap_,_ao_);
        return caml_call1(Fut[3],_aq_)}
      var
       _af_=caml_jsstring_of_string(rom_path),
       _ag_=0,
       _ah_=Brr_io[3][7],
       _ai_=caml_call2(_ah_,_ag_,_af_);
      return caml_call2(Fut[15][1],_ai_,_ae_)}
    function set_up_rom_selector(ctx,image_data,selector_el)
     {function _L_(rom_option)
       {var
         _W_=0,
         _X_=rom_option[1],
         _Y_=0,
         _Z_=Brr[9][3],
         ___=[0,caml_call2(_Z_,_Y_,_X_),_W_],
         _$_=0,
         _aa_=rom_option[2],
         _ab_=caml_jsstring_of_string(_aa_),
         _ac_=Brr[8][37],
         _ad_=[0,[0,caml_call1(_ac_,_ab_),_$_]];
        return caml_call3(Brr[9][130],0,_ad_,___)}
      var
       _M_=Stdlib_List[19],
       _N_=caml_call1(_M_,_L_),
       _O_=caml_call1(_N_,rom_options),
       _P_=Brr[9][20],
       _Q_=caml_call1(_P_,selector_el);
      caml_call1(_Q_,_O_);
      function on_change(param)
       {var
         _R_=Brr[9][27][10],
         _S_=Brr[9][28],
         _T_=caml_call2(_S_,_R_,selector_el),
         rom_path=caml_string_of_jsstring(_T_);
        function _U_(param){return 0}
        var _V_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_V_,_U_)}
      return caml_call4(Brr[7][20],0,Brr[7][44],on_change,selector_el)}
    function set_default_throttle_val(checkbox_el)
     {var
       _A_=Brr[16][5],
       _B_=Brr[13][12],
       uri=caml_call1(_B_,_A_),
       _C_=Brr[6][6],
       _D_=caml_call1(_C_,uri),
       _E_=Brr[6][9][7],
       _F_=caml_call1(_E_,_D_),
       _G_="throttled",
       _H_=Brr[6][9][3],
       _I_=caml_call1(_H_,_G_),
       param=caml_call1(_I_,_F_);
      function set_throttled_val(b)
       {var _J_=Brr[9][27][5],_K_=Brr[9][29];
        caml_call3(_K_,_J_,b,checkbox_el);
        throttled[1] = b;
        return 0}
      if(param)
       {var jstr=param[1],match=caml_string_of_jsstring(jstr);
        return caml_string_notequal(match,cst_false)
                ?set_throttled_val(1)
                :set_throttled_val(0)}
      return set_throttled_val(1)}
    function on_checkbox_change(checkbox_el)
     {var
       _y_=Brr[9][27][5],
       _z_=Brr[9][28],
       checked=caml_call2(_z_,_y_,checkbox_el);
      throttled[1] = checked;
      return 0}
    var
     _c_=find_el_by_id(cst_canvas),
     _d_=Brr_canvas[3][2],
     canvas=caml_call1(_d_,_c_),
     _e_=0,
     _f_=Brr_canvas[4][15],
     ctx=caml_call2(_f_,_e_,canvas),
     _g_=1.5,
     _h_=1.5,
     _i_=Brr_canvas[4][36];
    caml_call3(_i_,ctx,_h_,_g_);
    var
     _j_=Brr_canvas[4][91],
     image_data=caml_call3(_j_,ctx,gb_w,gb_h),
     _k_=-603547828,
     _l_=Stdlib_Array[3],
     fb=caml_call3(_l_,gb_h,gb_w,_k_);
    draw_framebuffer(ctx,image_data,fb);
    var checkbox_el=find_el_by_id(cst_throttle);
    set_default_throttle_val(checkbox_el);
    function _m_(param){return on_checkbox_change(checkbox_el)}
    var _n_=Brr[7][44],_o_=0,_p_=Brr[7][20];
    caml_call4(_p_,_o_,_n_,_m_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _q_(param){return on_load_rom(ctx,image_data,input_el)}
    var _r_=Brr[7][44],_s_=0,_t_=Brr[7][20];
    caml_call4(_t_,_s_,_r_,_q_,input_el);
    var selector_el=find_el_by_id(cst_rom_selector);
    set_up_rom_selector(ctx,image_data,selector_el);
    var
     _u_=Stdlib_List[5],
     rom=caml_call1(_u_,rom_options),
     _v_=rom[2],
     fut=run_selected_rom(ctx,image_data,_v_);
    function _w_(param){return 0}
    var _x_=Fut[2];
    caml_call2(_x_,fut,_w_);
    var Dune_exe_Index=[0];
    runtime.caml_register_global(51,Dune_exe_Index,"Dune__exe__Index");
    return}
  (globalThis));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiZmluZF9lbF9ieV9pZCIsImlkIiwiZHJhd19mcmFtZWJ1ZmZlciIsImN0eCIsImltYWdlX2RhdGEiLCJmYiIsImQiLCJ5IiwieCIsIm9mZiIsInJ1bl9pZCIsImtleV9kb3duX2xpc3RlbmVyIiwia2V5X3VwX2xpc3RlbmVyIiwic2V0X2xpc3RlbmVyIiwiZG93biIsInVwIiwiY2xlYXIiLCJ0aW1lcl9pZCIsImxpc3RlciIsImxpc3RlciQwIiwic2V0X3VwX2tleWJvYXJkIiwiQyIsInQiLCJldiIsImtleV9uYW1lIiwic2V0X3VwX2pveXBhZCIsInJpZ2h0X2VsIiwibGVmdF9lbCIsImRvd25fZWwiLCJ1cF9lbCIsImJfZWwiLCJhX2VsIiwic2VsZWN0X2VsIiwic3RhcnRfZWwiLCJ2aWJlcmF0ZSIsIm1zIiwibmF2aWdhdG9yIiwicHJlc3MiLCJrZXkiLCJyZWxlYXNlIiwibGlzdGVuX29wcyIsInRocm90dGxlZCIsInJ1bl9yb21fYnl0ZXMiLCJyb21fYnl0ZXMiLCJjYXJ0cmlkZ2UiLCJjbnQiLCJzdGFydF90aW1lIiwic2V0X2ZwcyIsImZwcyIsImZwc19zdHIiLCJmcHNfZWwiLCJtYWluX2xvb3AiLCJlbmRfdGltZSIsInNlY19wZXJfNjBfZnJhbWUiLCJydW5fcm9tX2Jsb2IiLCJyb21fYmxvYiIsInJlc3VsdCIsImJ1ZiIsImUiLCJvbl9sb2FkX3JvbSIsImlucHV0X2VsIiwiZmlsZSIsInJ1bl9zZWxlY3RlZF9yb20iLCJyb21fcGF0aCIsInJlc3BvbnNlIiwiYmxvYiIsInNldF91cF9yb21fc2VsZWN0b3IiLCJzZWxlY3Rvcl9lbCIsInJvbV9vcHRpb24iLCJvbl9jaGFuZ2UiLCJzZXRfZGVmYXVsdF90aHJvdHRsZV92YWwiLCJjaGVja2JveF9lbCIsInVyaSIsInBhcmFtIiwic2V0X3Rocm90dGxlZF92YWwiLCJiIiwianN0ciIsIm9uX2NoZWNrYm94X2NoYW5nZSIsImNoZWNrZWQiLCJjYW52YXMiLCJyb20iLCJmdXQiXSwic291cmNlcyI6WyIvd29ya3NwYWNlX3Jvb3QvYmluL3dlYi9pbmRleC5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBWUlBOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBTEFDO0tBQ0FDO2FBZUFDLGNBQWNDO01BQXVDO29DQUF2Q0E7T0FBdUM7O09BQWxDOzhDQUEyRDthQUU5RUMsaUJBQWlCQyxJQUFJQyxXQUFXQztNQUNsQyw4QkFBUSxrQkFEZUQsWUFFdkJHOztNQUNFOztRQUNFOztxQkFGSkEsZUFDRUM7V0FFUSxzQkFMd0JILEdBRWxDRTtXQUdnQiw0QkFGZEM7VUFFYzs7YUFZVixFQWJFQzthQWFGLFNBYkVBO2FBY0Y7YUFEQSxTQWJFQTthQWVGO2FBRkEsU0FiRUE7YUFnQkY7O2FBYkEsRUFIRUE7YUFHRixTQUhFQTthQUlGO2FBREEsU0FIRUE7YUFLRjthQUZBLFNBSEVBO2FBTUY7OzthQUVBLEVBUkVBO2FBUUYsU0FSRUE7YUFTRjthQURBLFNBUkVBO2FBVUY7YUFGQSxTQVJFQTthQVdGOzthQU9BLEVBbEJFQTthQWtCRixTQWxCRUE7YUFtQkY7YUFEQSxTQWxCRUE7YUFvQkY7YUFGQSxTQWxCRUE7YUFxQkY7VUFyQkYsU0FERkQ7O1VBQ0UsU0FGSkQ7O1VBMEJBLG9DQTVCbUJKLElBQUlDLGlCQTRCb0I7UUFJdkNNLGFBQ0FDLHdCQUNBQzthQUNBQyxhQUFhQyxLQUFLQztNQUNwQiwwQkFEZUQsTUFDZix3QkFEb0JDLElBQ3BCLFFBQzBCO2FBQ3hCQztNQUNGLFNBUEVOO01BT0Y7UUFHSTt3QkFES087UUFDTDtRQUNBLGdCQUZLQTtNQUZULFNBTkVOO01BWUY7UUFFbUI7Ozs7OztrQ0FBVk87TUFSVCxTQUxF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aUIsMEJBRmJBLElBdFBGTCxLQUNBQztLQXVQZTs7S0FDUixrQkF4UFBBLEtBREFEO0lBMFBGLGlCQUpJSyxJQUVBQyxXQUNBQztJQUpTLElBT1RrRSxZQUFjO0lBQ2xCLHlCQURJQTtJQUNKLG9CQUM4QiwwQkFGMUJBLFlBRXdEO0lBRDVEO0lBQ0EsMkJBRklBO0lBQ0osSUFHSVgsU0FBVzt3QkFDZSxtQkFYMUJ6RCxJQUVBQyxXQVFBd0QsU0FDNkQ7SUFEbEQ7SUFDZiwyQkFESUE7SUFBVyxJQUdYTyxZQUFjO0lBQ2xCLG9CQWRJaEUsSUFFQUMsV0FXQStEO0lBSFc7S0FJZjtLQUVVLG1CQWpRUnRFO0tBaVFRLElBQU5tRjtLQUNNLHFCQWpCTjdFLElBRUFDO0lBZU0sb0JBQ2UsUUFBRTtJQURqQjtJQUNWLGVBREk2RTtJQUFNO0lBQ1Y7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9jYW52YXNcbm9wZW4gQnJyX2lvXG5vcGVuIEZ1dC5TeW50YXhcblxuXG5sZXQgZ2JfdyA9IDE2MFxubGV0IGdiX2ggPSAxNDRcblxudHlwZSByb21fb3B0aW9uID0geyBuYW1lIDogc3RyaW5nOyBwYXRoIDogc3RyaW5nIH1cblxubGV0IHJvbV9vcHRpb25zID0gW1xuICB7bmFtZSA9IFwiVGhlIEJvdW5jaW5nIEJhbGxcIiA7IHBhdGggPSBcIi4vdGhlLWJvdW5jaW5nLWJhbGwuZ2JcIn07XG4gIHtuYW1lID0gXCJUb2J1IFRvYnUgR2lybFwiICAgIDsgcGF0aCA9IFwiLi90b2J1LmdiXCJ9O1xuICB7bmFtZSA9IFwiQ2F2ZXJuXCIgICAgICAgICAgICA7IHBhdGggPSBcIi4vY2F2ZXJuLmdiXCJ9O1xuICB7bmFtZSA9IFwiSW50byBUaGUgQmx1ZVwiICAgICA7IHBhdGggPSBcIi4vaW50by10aGUtYmx1ZS5nYlwifTtcbiAge25hbWUgPSBcIlJvY2tldCBNYW4gRGVtb1wiICAgOyBwYXRoID0gXCIuL3JvY2tldC1tYW4tZGVtby5nYlwifTtcbiAge25hbWUgPSBcIlJldHJvaWRcIiAgICAgICAgICAgOyBwYXRoID0gXCIuL3JldHJvaWQuZ2JcIn07XG4gIHtuYW1lID0gXCJXaXNoaW5nIFNhcmFoXCIgICAgIDsgcGF0aCA9IFwiLi9kcmVhbWluZy1zYXJhaC5nYlwifTtcbiAge25hbWUgPSBcIlNIRUVQIElUIFVQXCIgICAgICAgOyBwYXRoID0gXCIuL3NoZWVwLWl0LXVwLmdiXCJ9O1xuXVxuXG5sZXQgZmluZF9lbF9ieV9pZCBpZCA9IERvY3VtZW50LmZpbmRfZWxfYnlfaWQgRy5kb2N1bWVudCAoSnN0ci52IGlkKSB8PiBPcHRpb24uZ2V0XG5cbmxldCBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiID1cbiAgbGV0IGQgPSBDMmQuSW1hZ2VfZGF0YS5kYXRhIGltYWdlX2RhdGEgaW5cbiAgZm9yIHkgPSAwIHRvIGdiX2ggLSAxIGRvXG4gICAgZm9yIHggPSAwIHRvIGdiX3cgLSAxIGRvXG4gICAgICBsZXQgb2ZmID0gNCAqICh5ICogZ2JfdyArIHgpIGluXG4gICAgICBtYXRjaCBmYi4oeSkuKHgpIHdpdGhcbiAgICAgIHwgYFdoaXRlIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHhFNTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweEZCO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4RjQ7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYExpZ2h0X2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDk3O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4QUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhCODtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgRGFya19ncmF5IC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHg2MTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDY4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4N0Q7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYEJsYWNrIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHgyMjtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDFFO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4MzE7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICBkb25lXG4gIGRvbmU7XG4gIEMyZC5wdXRfaW1hZ2VfZGF0YSBjdHggaW1hZ2VfZGF0YSB+eDowIH55OjBcblxuKCoqIE1hbmFnZXMgc3RhdGUgdGhhdCBuZWVkIHRvIGJlIHJlc2V0IHdoZW4gbG9hZGluZyBhIG5ldyByb20gKilcbm1vZHVsZSBTdGF0ZSA9IHN0cnVjdFxuICBsZXQgcnVuX2lkID0gcmVmIE5vbmVcbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IGtleV91cF9saXN0ZW5lciA9IHJlZiBOb25lXG4gIGxldCBzZXRfbGlzdGVuZXIgZG93biB1cCA9XG4gICAga2V5X2Rvd25fbGlzdGVuZXIgOj0gU29tZSBkb3duO1xuICAgIGtleV91cF9saXN0ZW5lciA6PSBTb21lIHVwXG4gIGxldCBjbGVhciAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggIXJ1bl9pZCB3aXRoXG4gICAgICB8IE5vbmUgLT4gKClcbiAgICAgIHwgU29tZSB0aW1lcl9pZCAtPlxuICAgICAgICBHLnN0b3BfdGltZXIgdGltZXJfaWQ7XG4gICAgICAgIEcuY2FuY2VsX2FuaW1hdGlvbl9mcmFtZSB0aW1lcl9pZDtcbiAgICBlbmQ7XG4gICAgYmVnaW4gbWF0Y2ggIWtleV9kb3duX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXlkb3duIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X3VwX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXl1cCBsaXN0ZXIgRy50YXJnZXRcbiAgICBlbmRcbmVuZFxuXG5sZXQgc2V0X3VwX2tleWJvYXJkICh0eXBlIGEpIChtb2R1bGUgQyA6IENhbWxib3lfaW50Zi5TIHdpdGggdHlwZSB0ID0gYSkgKHQgOiBhKSA9XG4gIGxldCBrZXlfZG93bl9saXN0ZW5lciBldiA9XG4gICAgbGV0IGtleV9ldiA9IEV2LmFzX3R5cGUgZXYgaW5cbiAgICBsZXQga2V5X25hbWUgPSBrZXlfZXYgfD4gRXYuS2V5Ym9hcmQua2V5IHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgbWF0Y2gga2V5X25hbWUgd2l0aFxuICAgIHwgXCJFbnRlclwiIC0+IEMucHJlc3MgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucHJlc3MgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnByZXNzIHQgQlxuICAgIHwgXCJrXCIgICAgIC0+IEMucHJlc3MgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5wcmVzcyB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5wcmVzcyB0IExlZnRcbiAgICB8IFwic1wiICAgICAtPiBDLnByZXNzIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucHJlc3MgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBsZXQga2V5X3VwX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5yZWxlYXNlIHQgU3RhcnRcbiAgICB8IFwiU2hpZnRcIiAtPiBDLnJlbGVhc2UgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnJlbGVhc2UgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5yZWxlYXNlIHQgQVxuICAgIHwgXCJ3XCIgICAgIC0+IEMucmVsZWFzZSB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5yZWxlYXNlIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucmVsZWFzZSB0IERvd25cbiAgICB8IFwiZFwiICAgICAtPiBDLnJlbGVhc2UgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBFdi5saXN0ZW4gRXYua2V5ZG93biAoa2V5X2Rvd25fbGlzdGVuZXIpIEcudGFyZ2V0O1xuICBFdi5saXN0ZW4gRXYua2V5dXAgKGtleV91cF9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIFN0YXRlLnNldF9saXN0ZW5lciBrZXlfZG93bl9saXN0ZW5lciBrZXlfdXBfbGlzdGVuZXJcblxubGV0IHNldF91cF9qb3lwYWQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IHVwX2VsLCBkb3duX2VsLCBsZWZ0X2VsLCByaWdodF9lbCA9XG4gICAgZmluZF9lbF9ieV9pZCBcInVwXCIsIGZpbmRfZWxfYnlfaWQgXCJkb3duXCIsIGZpbmRfZWxfYnlfaWQgXCJsZWZ0XCIsIGZpbmRfZWxfYnlfaWQgXCJyaWdodFwiIGluXG4gIGxldCBhX2VsLCBiX2VsID0gZmluZF9lbF9ieV9pZCBcImFcIiwgZmluZF9lbF9ieV9pZCBcImJcIiBpblxuICBsZXQgc3RhcnRfZWwsIHNlbGVjdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJzdGFydFwiLCBmaW5kX2VsX2J5X2lkIFwic2VsZWN0XCIgaW5cbiAgbGV0IHZpYmVyYXRlIG1zID1cbiAgICBsZXQgbmF2aWdhdG9yID0gRy5uYXZpZ2F0b3IgfD4gTmF2aWdhdG9yLnRvX2p2IGluXG4gICAgaWdub3JlIEBAIEp2LmNhbGwgbmF2aWdhdG9yIFwidmlicmF0ZVwiIEp2Llt8IG9mX2ludCBtcyB8XVxuICBpblxuICAoKiBUT0RPOiB1bmxpc3RlbiB0aGVzZSBsaXN0ZW5lciBvbiByb20gY2hhbmdlICopXG4gIGxldCBwcmVzcyBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgdmliZXJhdGUgMTA7IEMucHJlc3MgdCBrZXkgaW5cbiAgbGV0IHJlbGVhc2UgZXYgdCBrZXkgPSBFdi5wcmV2ZW50X2RlZmF1bHQgZXY7IEMucmVsZWFzZSB0IGtleSBpblxuICBsZXQgbGlzdGVuX29wcyA9IEV2Lmxpc3Rlbl9vcHRzIH5jYXB0dXJlOnRydWUgKCkgaW5cbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKVxuXG5sZXQgdGhyb3R0bGVkID0gcmVmIHRydWVcblxubGV0IHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzID1cbiAgU3RhdGUuY2xlYXIgKCk7XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OnRydWUgfnJvbV9ieXRlcyBpblxuICBzZXRfdXBfa2V5Ym9hcmQgKG1vZHVsZSBDKSB0O1xuICBzZXRfdXBfam95cGFkIChtb2R1bGUgQykgdDtcbiAgbGV0IGNudCA9IHJlZiAwIGluXG4gIGxldCBzdGFydF90aW1lID0gcmVmIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgaW5cbiAgbGV0IHNldF9mcHMgZnBzID1cbiAgICBsZXQgZnBzX3N0ciA9IFByaW50Zi5zcHJpbnRmIFwiJS4xZlwiIGZwcyBpblxuICAgIGxldCBmcHNfZWwgPSBmaW5kX2VsX2J5X2lkIFwiZnBzXCIgaW5cbiAgICBFbC5zZXRfY2hpbGRyZW4gZnBzX2VsIFtFbC50eHQgKEpzdHIudiBmcHNfc3RyKV1cbiAgaW5cbiAgbGV0IHJlYyBtYWluX2xvb3AgKCkgPVxuICAgIGJlZ2luIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgICAgfCBJbl9mcmFtZSAtPlxuICAgICAgICBtYWluX2xvb3AgKClcbiAgICAgIHwgRnJhbWVfZW5kZWQgZmIgLT5cbiAgICAgICAgaW5jciBjbnQ7XG4gICAgICAgIGlmICFjbnQgPSA2MCB0aGVuIGJlZ2luXG4gICAgICAgICAgbGV0IGVuZF90aW1lID0gUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UgaW5cbiAgICAgICAgICBsZXQgc2VjX3Blcl82MF9mcmFtZSA9IChlbmRfdGltZSAtLiAhc3RhcnRfdGltZSkgLy4gMTAwMC4gaW5cbiAgICAgICAgICBsZXQgZnBzID0gNjAuIC8uICBzZWNfcGVyXzYwX2ZyYW1lIGluXG4gICAgICAgICAgc3RhcnRfdGltZSA6PSBlbmRfdGltZTtcbiAgICAgICAgICBzZXRfZnBzIGZwcztcbiAgICAgICAgICBjbnQgOj0gMDtcbiAgICAgICAgZW5kO1xuICAgICAgICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAgICAgICBpZiBub3QgIXRocm90dGxlZCB0aGVuXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcuc2V0X3RpbWVvdXQgfm1zOjAgbWFpbl9sb29wKVxuICAgICAgICBlbHNlXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcucmVxdWVzdF9hbmltYXRpb25fZnJhbWUgKGZ1biBfIC0+IG1haW5fbG9vcCAoKSkpXG4gICAgZW5kO1xuICBpblxuICBtYWluX2xvb3AgKClcblxubGV0IHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSByb21fYmxvYiA9XG4gIGxldCogcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgRnV0LnJldHVybiBAQCBydW5fcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhIHJvbV9ieXRlc1xuICB8IEVycm9yIGUgLT5cbiAgICBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsID1cbiAgbGV0IGZpbGUgPSBFbC5JbnB1dC5maWxlcyBpbnB1dF9lbCB8PiBMaXN0LmhkIGluXG4gIGxldCBibG9iID0gRmlsZS5hc19ibG9iIGZpbGUgaW5cbiAgRnV0LmF3YWl0IChydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYikgKGZ1biAoKSAtPiAoKSlcblxubGV0IHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tX3BhdGggPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIGJsb2JcbiAgICAgIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG5cbmxldCBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsID1cbiAgcm9tX29wdGlvbnNcbiAgfD4gTGlzdC5tYXAgKGZ1biByb21fb3B0aW9uIC0+XG4gICAgICBFbC5vcHRpb25cbiAgICAgICAgfmF0OkF0Llt2YWx1ZSAoSnN0ci52IHJvbV9vcHRpb24ucGF0aCldXG4gICAgICAgIFtFbC50eHQnIHJvbV9vcHRpb24ubmFtZV0pXG4gIHw+IEVsLmFwcGVuZF9jaGlsZHJlbiBzZWxlY3Rvcl9lbDtcbiAgbGV0IG9uX2NoYW5nZSBfID1cbiAgICBsZXQgcm9tX3BhdGggPSBFbC5wcm9wIChFbC5Qcm9wLnZhbHVlKSBzZWxlY3Rvcl9lbCB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIEZ1dC5hd2FpdCAocnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCkgKGZ1biAoKSAtPiAoKSlcbiAgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSBvbl9jaGFuZ2UgKEVsLmFzX3RhcmdldCBzZWxlY3Rvcl9lbClcblxubGV0IHNldF9kZWZhdWx0X3Rocm90dGxlX3ZhbCBjaGVja2JveF9lbCA9XG4gIGxldCB1cmkgPSBXaW5kb3cubG9jYXRpb24gRy53aW5kb3cgaW5cbiAgbGV0IHBhcmFtID1cbiAgICB1cmlcbiAgICB8PiBVcmkucXVlcnlcbiAgICB8PiBVcmkuUGFyYW1zLm9mX2pzdHJcbiAgICB8PiBVcmkuUGFyYW1zLmZpbmQgSnN0ci4odiBcInRocm90dGxlZFwiKVxuICBpblxuICBsZXQgc2V0X3Rocm90dGxlZF92YWwgYiA9XG4gICAgRWwuc2V0X3Byb3AgKEVsLlByb3AuY2hlY2tlZCkgYiBjaGVja2JveF9lbDtcbiAgICB0aHJvdHRsZWQgOj0gYlxuICBpblxuICBtYXRjaCBwYXJhbSB3aXRoXG4gIHwgU29tZSBqc3RyIC0+XG4gICAgYmVnaW4gbWF0Y2ggSnN0ci50b19zdHJpbmcganN0ciB3aXRoXG4gICAgICB8IFwiZmFsc2VcIiAtPiBzZXRfdGhyb3R0bGVkX3ZhbCBmYWxzZVxuICAgICAgfCBfICAgICAgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuICAgIGVuZFxuICB8IE5vbmUgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuXG5sZXQgb25fY2hlY2tib3hfY2hhbmdlIGNoZWNrYm94X2VsID1cbiAgbGV0IGNoZWNrZWQgPSBFbC5wcm9wIChFbC5Qcm9wLmNoZWNrZWQpIGNoZWNrYm94X2VsIGluXG4gIHRocm90dGxlZCA6PSBjaGVja2VkXG5cbmxldCAoKSA9XG4gICgqIFNldCB1cCBjYW52YXMgKilcbiAgbGV0IGNhbnZhcyA9IGZpbmRfZWxfYnlfaWQgXCJjYW52YXNcIiB8PiBDYW52YXMub2ZfZWwgaW5cbiAgbGV0IGN0eCA9IEMyZC5jcmVhdGUgY2FudmFzIGluXG4gIEMyZC5zY2FsZSBjdHggfnN4OjEuNSB+c3k6MS41O1xuICBsZXQgaW1hZ2VfZGF0YSA9IEMyZC5jcmVhdGVfaW1hZ2VfZGF0YSBjdHggfnc6Z2JfdyB+aDpnYl9oIGluXG4gIGxldCBmYiA9IEFycmF5Lm1ha2VfbWF0cml4IGdiX2ggZ2JfdyBgTGlnaHRfZ3JheSBpblxuICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAoKiBTZXQgdXAgdGhyb3R0bGUgY2hlY2tib3ggKilcbiAgbGV0IGNoZWNrYm94X2VsID0gZmluZF9lbF9ieV9pZCBcInRocm90dGxlXCIgaW5cbiAgc2V0X2RlZmF1bHRfdGhyb3R0bGVfdmFsIGNoZWNrYm94X2VsO1xuICBFdi5saXN0ZW4gRXYuY2hhbmdlIChmdW4gXyAtPiBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwpIChFbC5hc190YXJnZXQgY2hlY2tib3hfZWwpO1xuICAoKiBTZXQgdXAgbG9hZCByb20gYnV0dG9uICopXG4gIGxldCBpbnB1dF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJsb2FkLXJvbVwiIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsKSAoRWwuYXNfdGFyZ2V0IGlucHV0X2VsKTtcbiAgKCogU2V0IHVwIHJvbSBzZWxlY3RvciAqKVxuICBsZXQgc2VsZWN0b3JfZWwgPSBmaW5kX2VsX2J5X2lkIFwicm9tLXNlbGVjdG9yXCIgaW5cbiAgc2V0X3VwX3JvbV9zZWxlY3RvciBjdHggaW1hZ2VfZGF0YSBzZWxlY3Rvcl9lbDtcbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgcm9tID0gTGlzdC5oZCByb21fb3B0aW9ucyBpblxuICBsZXQgZnV0ID0gcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb20ucGF0aCBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gKCkgLT4gKCkpXG4iXX0=
