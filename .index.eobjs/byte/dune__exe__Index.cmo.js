(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
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
    function alert(v)
     {var _cV_=Jv[12],alert=_cV_.alert,_cW_=Jv[23],_cX_=caml_call1(_cW_,v);
      alert(_cX_);
      return 0}
    function console_log(s)
     {var _cU_=0;
      return caml_call1(Brr[12][9],[0,caml_jsstring_of_string(s),_cU_])}
    function find_el_by_id(id)
     {var
       _cQ_=caml_jsstring_of_string(id),
       _cR_=Brr[16][2],
       _cS_=Brr[10][2],
       _cT_=caml_call2(_cS_,_cR_,_cQ_);
      return caml_call1(Stdlib_Option[4],_cT_)}
    function draw_framebuffer(ctx,image_data,fb)
     {var _cA_=Brr_canvas[4][90][4],d=caml_call1(_cA_,image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           _cC_=caml_check_bound(fb,y)[1 + y],
           match=caml_check_bound(_cC_,x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 97;
             var _cD_=off + 1 | 0;
             d[_cD_] = 104;
             var _cE_=off + 2 | 0;
             d[_cE_] = 125;
             var _cF_=off + 3 | 0;
             d[_cF_] = 255}
           else
            {d[off] = 229;
             var _cH_=off + 1 | 0;
             d[_cH_] = 251;
             var _cI_=off + 2 | 0;
             d[_cI_] = 244;
             var _cJ_=off + 3 | 0;
             d[_cJ_] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             var _cK_=off + 1 | 0;
             d[_cK_] = 174;
             var _cL_=off + 2 | 0;
             d[_cL_] = 184;
             var _cM_=off + 3 | 0;
             d[_cM_] = 255}
           else
            {d[off] = 34;
             var _cN_=off + 1 | 0;
             d[_cN_] = 30;
             var _cO_=off + 2 | 0;
             d[_cO_] = 49;
             var _cP_=off + 3 | 0;
             d[_cP_] = 255}
          var _cG_=x + 1 | 0;
          if(159 !== x){var x=_cG_;continue}
          var _cB_=y + 1 | 0;
          if(143 !== y){var y=_cB_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _cr_=run_id[1];
      if(_cr_)
       {var timer_id=_cr_[1],_cs_=Brr[16][10];
        caml_call1(_cs_,timer_id);
        var _ct_=Brr[16][12];
        caml_call1(_ct_,timer_id)}
      var _cu_=key_down_listener[1];
      if(_cu_)
       {var
         lister=_cu_[1],
         _cv_=Brr[16][6],
         _cw_=Brr[7][76],
         _cx_=0,
         _cy_=Brr[7][21];
        caml_call4(_cy_,_cx_,_cw_,lister,_cv_)}
      var _cz_=key_up_listener[1];
      if(_cz_)
       {var lister$0=_cz_[1];
        return caml_call4(Brr[7][21],0,Brr[7][77],lister$0,Brr[16][6])}
      return 0}
    var State=[0,run_id,key_down_listener,key_up_listener,set_listener,clear];
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var
           _cp_=Brr[7][31][2],
           _cq_=caml_call1(_cp_,ev),
           key_name=caml_string_of_jsstring(_cq_);
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
           _cn_=Brr[7][31][2],
           _co_=caml_call1(_cn_,ev),
           key_name=caml_string_of_jsstring(_co_);
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
        var _cf_=Brr[16][6],_cg_=Brr[7][76],_ch_=0,_ci_=Brr[7][20];
        caml_call4(_ci_,_ch_,_cg_,key_down_listener,_cf_);
        var _cj_=Brr[16][6],_ck_=Brr[7][77],_cl_=0,_cm_=Brr[7][20];
        caml_call4(_cm_,_cl_,_ck_,key_up_listener,_cj_);
        return caml_call2(State[4],key_down_listener,key_up_listener)}}
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
         {var _cd_=Brr[7][13];
          caml_call1(_cd_,ev);
          var _ce_=10;
          viberate(_ce_);
          return caml_call2(C[4],t,key)}
        function release(ev,t,key)
         {var _cc_=Brr[7][13];
          caml_call1(_cc_,ev);
          return caml_call2(C[5],t,key)}
        var
         _bb_=0,
         _bc_=0,
         _bd_=0,
         _be_=Brr[7][19],
         listen_ops=caml_call4(_be_,_a_,_bd_,_bc_,_bb_);
        function _bf_(ev){return press(ev,t,1)}
        var _bg_=Dune_exe_My_ev[2],_bh_=[0,listen_ops],_bi_=Brr[7][20];
        caml_call4(_bi_,_bh_,_bg_,_bf_,up_el);
        function _bj_(ev){return press(ev,t,0)}
        var _bk_=Dune_exe_My_ev[2],_bl_=[0,listen_ops],_bm_=Brr[7][20];
        caml_call4(_bm_,_bl_,_bk_,_bj_,down_el);
        function _bn_(ev){return press(ev,t,2)}
        var _bo_=Dune_exe_My_ev[2],_bp_=[0,listen_ops],_bq_=Brr[7][20];
        caml_call4(_bq_,_bp_,_bo_,_bn_,left_el);
        function _br_(ev){return press(ev,t,3)}
        var _bs_=Dune_exe_My_ev[2],_bt_=[0,listen_ops],_bu_=Brr[7][20];
        caml_call4(_bu_,_bt_,_bs_,_br_,right_el);
        function _bv_(ev){return press(ev,t,7)}
        var _bw_=Dune_exe_My_ev[2],_bx_=[0,listen_ops],_by_=Brr[7][20];
        caml_call4(_by_,_bx_,_bw_,_bv_,a_el);
        function _bz_(ev){return press(ev,t,6)}
        var _bA_=Dune_exe_My_ev[2],_bB_=[0,listen_ops],_bC_=Brr[7][20];
        caml_call4(_bC_,_bB_,_bA_,_bz_,b_el);
        function _bD_(ev){return press(ev,t,4)}
        var _bE_=Dune_exe_My_ev[2],_bF_=[0,listen_ops],_bG_=Brr[7][20];
        caml_call4(_bG_,_bF_,_bE_,_bD_,start_el);
        function _bH_(ev){return press(ev,t,5)}
        var _bI_=Dune_exe_My_ev[2],_bJ_=[0,listen_ops],_bK_=Brr[7][20];
        caml_call4(_bK_,_bJ_,_bI_,_bH_,select_el);
        function _bL_(ev){return release(ev,t,1)}
        var _bM_=Dune_exe_My_ev[3],_bN_=[0,listen_ops],_bO_=Brr[7][20];
        caml_call4(_bO_,_bN_,_bM_,_bL_,up_el);
        function _bP_(ev){return release(ev,t,0)}
        var _bQ_=Dune_exe_My_ev[3],_bR_=[0,listen_ops],_bS_=Brr[7][20];
        caml_call4(_bS_,_bR_,_bQ_,_bP_,down_el);
        function _bT_(ev){return release(ev,t,2)}
        var _bU_=Dune_exe_My_ev[3],_bV_=[0,listen_ops],_bW_=Brr[7][20];
        caml_call4(_bW_,_bV_,_bU_,_bT_,left_el);
        function _bX_(ev){return release(ev,t,3)}
        var _bY_=Dune_exe_My_ev[3],_bZ_=[0,listen_ops],_b0_=Brr[7][20];
        caml_call4(_b0_,_bZ_,_bY_,_bX_,right_el);
        function _b1_(ev){return release(ev,t,7)}
        var _b2_=Dune_exe_My_ev[3],_b3_=[0,listen_ops],_b4_=Brr[7][20];
        caml_call4(_b4_,_b3_,_b2_,_b1_,a_el);
        function _b5_(ev){return release(ev,t,6)}
        var _b6_=Dune_exe_My_ev[3],_b7_=[0,listen_ops],_b8_=Brr[7][20];
        caml_call4(_b8_,_b7_,_b6_,_b5_,b_el);
        function _b9_(ev){return release(ev,t,4)}
        var _b__=Dune_exe_My_ev[3],_b$_=[0,listen_ops],_ca_=Brr[7][20];
        caml_call4(_ca_,_b$_,_b__,_b9_,start_el);
        function _cb_(ev){return release(ev,t,5)}
        return caml_call4
                (Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_cb_,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {var _aP_=0,_aQ_=State[5];
      caml_call1(_aQ_,_aP_);
      var
       _aR_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_aR_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _aS_=1,
       _aT_=C[2],
       t=caml_call2(_aT_,_aS_,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var
       cnt=[0,0],
       _aU_=Brr[16][4],
       _aV_=Brr[15][9],
       start_time=[0,caml_call1(_aV_,_aU_)];
      function set_fps(fps)
       {var
         _a7_=Stdlib_Printf[4],
         fps_str=caml_call2(_a7_,_b_,fps),
         fps_el=find_el_by_id(cst_fps),
         _a8_=0,
         _a9_=caml_jsstring_of_string(fps_str),
         _a__=0,
         _a$_=Brr[9][2],
         _ba_=[0,caml_call2(_a$_,_a__,_a9_),_a8_];
        return caml_call2(Brr[9][18],fps_el,_ba_)}
      function main_loop(param)
       {for(;;)
         {var _aW_=C[3],match=caml_call1(_aW_,t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               _aX_=Brr[16][4],
               _aY_=Brr[15][9],
               end_time=caml_call1(_aY_,_aX_),
               _aZ_=start_time[1],
               _a0_=end_time - _aZ_,
               sec_per_60_frame=_a0_ / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              set_fps(fps);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var
               _a1_=function(param){return main_loop(0)},
               _a2_=Brr[16][11],
               _a3_=[0,caml_call1(_a2_,_a1_)];
              State[1][1] = _a3_;
              return 0}
            var
             _a4_=0,
             _a5_=Brr[16][8],
             _a6_=[0,caml_call2(_a5_,_a4_,main_loop)];
            State[1][1] = _a6_;
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
       _aw_=Brr[9][56][1],
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
        return caml_call3(Brr[9][127],0,_ad_,___)}
      var
       _M_=Stdlib_List[19],
       _N_=caml_call1(_M_,_L_),
       _O_=caml_call1(_N_,rom_options),
       _P_=Brr[9][20],
       _Q_=caml_call1(_P_,selector_el);
      caml_call1(_Q_,_O_);
      function on_change(param)
       {var
         _R_=Brr[9][25][10],
         _S_=Brr[9][26],
         _T_=caml_call2(_S_,_R_,selector_el),
         rom_path=caml_string_of_jsstring(_T_);
        function _U_(param){return 0}
        var _V_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_V_,_U_)}
      return caml_call4(Brr[7][20],0,Brr[7][43],on_change,selector_el)}
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
       {var _J_=Brr[9][25][5],_K_=Brr[9][27];
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
       _y_=Brr[9][25][5],
       _z_=Brr[9][26],
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
    var _n_=Brr[7][43],_o_=0,_p_=Brr[7][20];
    caml_call4(_p_,_o_,_n_,_m_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _q_(param){return on_load_rom(ctx,image_data,input_el)}
    var _r_=Brr[7][43],_s_=0,_t_=Brr[7][20];
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
    var
     Dune_exe_Index=
      [0,
       gb_w,
       gb_h,
       rom_options,
       alert,
       console_log,
       find_el_by_id,
       draw_framebuffer,
       State,
       set_up_keyboard,
       set_up_joypad,
       throttled,
       run_rom_bytes,
       run_rom_blob,
       on_load_rom,
       run_selected_rom,
       set_up_rom_selector,
       set_default_throttle_val,
       on_checkbox_change];
    runtime.caml_register_global(52,Dune_exe_Index,"Dune__exe__Index");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwiY29uc29sZV9sb2ciLCJzIiwiZmluZF9lbF9ieV9pZCIsImlkIiwiZHJhd19mcmFtZWJ1ZmZlciIsImN0eCIsImltYWdlX2RhdGEiLCJmYiIsImQiLCJ5IiwieCIsIm9mZiIsInJ1bl9pZCIsImtleV9kb3duX2xpc3RlbmVyIiwia2V5X3VwX2xpc3RlbmVyIiwic2V0X2xpc3RlbmVyIiwiZG93biIsInVwIiwiY2xlYXIiLCJ0aW1lcl9pZCIsImxpc3RlciIsImxpc3RlciQwIiwic2V0X3VwX2tleWJvYXJkIiwiQyIsInQiLCJldiIsImtleV9uYW1lIiwic2V0X3VwX2pveXBhZCIsInJpZ2h0X2VsIiwibGVmdF9lbCIsImRvd25fZWwiLCJ1cF9lbCIsImJfZWwiLCJhX2VsIiwic2VsZWN0X2VsIiwic3RhcnRfZWwiLCJ2aWJlcmF0ZSIsIm1zIiwibmF2aWdhdG9yIiwicHJlc3MiLCJrZXkiLCJyZWxlYXNlIiwibGlzdGVuX29wcyIsInRocm90dGxlZCIsInJ1bl9yb21fYnl0ZXMiLCJyb21fYnl0ZXMiLCJjYXJ0cmlkZ2UiLCJjbnQiLCJzdGFydF90aW1lIiwic2V0X2ZwcyIsImZwcyIsImZwc19zdHIiLCJmcHNfZWwiLCJtYWluX2xvb3AiLCJlbmRfdGltZSIsInNlY19wZXJfNjBfZnJhbWUiLCJydW5fcm9tX2Jsb2IiLCJyb21fYmxvYiIsInJlc3VsdCIsImJ1ZiIsImUiLCJvbl9sb2FkX3JvbSIsImlucHV0X2VsIiwiZmlsZSIsInJ1bl9zZWxlY3RlZF9yb20iLCJyb21fcGF0aCIsInJlc3BvbnNlIiwiYmxvYiIsInNldF91cF9yb21fc2VsZWN0b3IiLCJzZWxlY3Rvcl9lbCIsInJvbV9vcHRpb24iLCJvbl9jaGFuZ2UiLCJzZXRfZGVmYXVsdF90aHJvdHRsZV92YWwiLCJjaGVja2JveF9lbCIsInVyaSIsInBhcmFtIiwic2V0X3Rocm90dGxlZF92YWwiLCJiIiwianN0ciIsIm9uX2NoZWNrYm94X2NoYW5nZSIsImNoZWNrZWQiLCJjYW52YXMiLCJyb20iLCJmdXQiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkL2RlZmF1bHQvYmluL3dlYi9pbmRleC5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBWUlBOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBTEFDO0tBQ0FDO2FBZUFDLE1BQU1DO01BQ1IsZ0JBQVksNkJBQ21CLHFCQUZ2QkE7TUFFRTtjQUFtQzthQUUzQ0MsWUFBWUM7TUFBSTtNQUFrQix3REFBdEJBLFNBQWtDO2FBRTlDQyxjQUFjQztNQUF1QztvQ0FBdkNBO09BQXVDOztPQUFsQzs4Q0FBMkQ7YUFFOUVDLGlCQUFpQkMsSUFBSUMsV0FBV0M7TUFDbEMsOEJBQVEsa0JBRGVELFlBRXZCRzs7TUFDRTs7UUFDRTs7cUJBRkpBLGVBQ0VDO1dBRVEsc0JBTHdCSCxHQUVsQ0U7V0FHZ0IsNEJBRmRDO1VBRWM7O2FBWVYsRUFiRUM7YUFhRixTQWJFQTthQWNGO2FBREEsU0FiRUE7YUFlRjthQUZBLFNBYkVBO2FBZ0JGOzthQWJBLEVBSEVBO2FBR0YsU0FIRUE7YUFJRjthQURBLFNBSEVBO2FBS0Y7YUFGQSxTQUhFQTthQU1GOzs7YUFFQSxFQVJFQTthQVFGLFNBUkVBO2FBU0Y7YUFEQSxTQVJFQTthQVVGO2FBRkEsU0FSRUE7YUFXRjs7YUFPQSxFQWxCRUE7YUFrQkYsU0FsQkVBO2FBbUJGO2FBREEsU0FsQkVBO2FBb0JGO2FBRkEsU0FsQkVBO2FBcUJGO1VBckJGLFNBREZEOztVQUNFLFNBRkpEOztVQTBCQSxvQ0E1Qm1CSixJQUFJQyxpQkE0Qm9CO1FBSXZDTSxhQUNBQyx3QkFDQUM7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b0JJO1FBQ3BCLFFBQ2M7TUFKeUIsR0FKckNGO1FBWUYsU0FaRUEsU0FZRiw4QkFES0c7UUFDTDtpQkFFYztpQkFEQztNQUdQLDJCQUFzQjthQUU5QkMsbUJBQW1CTjtNQUNyQjs7O09BQWMsMkJBRE9BO01BQ1AsZUFBVk87TUFBVSxRQUNNO0lBSVA7Ozs7OztLQUNILHVCQUROQztLQUNNOzs7SUFDVixlQURJNUU7SUFEUztLQUViO0tBQ2lCLDBCQUZiQSxJQTVQRlQsS0FDQUM7S0E2UGU7O0tBQ1Isa0JBOVBQQSxLQURBRDtJQWdRRixpQkFKSVMsSUFFQUMsV0FDQUM7SUFKUyxJQU9Ua0UsWUFBYztJQUNsQix5QkFESUE7SUFDSixvQkFDOEIsMEJBRjFCQSxZQUV3RDtJQUQ1RDtJQUNBLDJCQUZJQTtJQUNKLElBR0lYLFNBQVc7d0JBQ2UsbUJBWDFCekQsSUFFQUMsV0FRQXdELFNBQzZEO0lBRGxEO0lBQ2YsMkJBRElBO0lBQVcsSUFHWE8sWUFBYztJQUNsQixvQkFkSWhFLElBRUFDLFdBV0ErRDtJQUhXO0tBSWY7S0FFVSxtQkF2UVIxRTtLQXVRUSxJQUFOdUY7S0FDTSxxQkFqQk43RSxJQUVBQztJQWVNLG9CQUNlLFFBQUU7SUFEakI7SUFDVixlQURJNkU7SUFBTTs7O09BN1FSdkY7T0FDQUM7T0FJQUY7T0FXQUc7T0FJQUU7T0FFQUU7T0FFQUU7O09BdURBa0I7T0FpQ0FLO09BOEJBZ0I7T0FFQUM7T0FxQ0FZO09BY0FLO09BS0FHO09BWUFJO09BYUFJO09Bb0JBTztJQXlCRjtVIiwic291cmNlc0NvbnRlbnQiOlsib3BlbiBDYW1sYm95X2xpYlxub3BlbiBCcnJcbm9wZW4gQnJyX2NhbnZhc1xub3BlbiBCcnJfaW9cbm9wZW4gRnV0LlN5bnRheFxuXG5cbmxldCBnYl93ID0gMTYwXG5sZXQgZ2JfaCA9IDE0NFxuXG50eXBlIHJvbV9vcHRpb24gPSB7IG5hbWUgOiBzdHJpbmc7IHBhdGggOiBzdHJpbmcgfVxuXG5sZXQgcm9tX29wdGlvbnMgPSBbXG4gIHtuYW1lID0gXCJUaGUgQm91bmNpbmcgQmFsbFwiIDsgcGF0aCA9IFwiLi90aGUtYm91bmNpbmctYmFsbC5nYlwifTtcbiAge25hbWUgPSBcIlRvYnUgVG9idSBHaXJsXCIgICAgOyBwYXRoID0gXCIuL3RvYnUuZ2JcIn07XG4gIHtuYW1lID0gXCJDYXZlcm5cIiAgICAgICAgICAgIDsgcGF0aCA9IFwiLi9jYXZlcm4uZ2JcIn07XG4gIHtuYW1lID0gXCJJbnRvIFRoZSBCbHVlXCIgICAgIDsgcGF0aCA9IFwiLi9pbnRvLXRoZS1ibHVlLmdiXCJ9O1xuICB7bmFtZSA9IFwiUm9ja2V0IE1hbiBEZW1vXCIgICA7IHBhdGggPSBcIi4vcm9ja2V0LW1hbi1kZW1vLmdiXCJ9O1xuICB7bmFtZSA9IFwiUmV0cm9pZFwiICAgICAgICAgICA7IHBhdGggPSBcIi4vcmV0cm9pZC5nYlwifTtcbiAge25hbWUgPSBcIldpc2hpbmcgU2FyYWhcIiAgICAgOyBwYXRoID0gXCIuL2RyZWFtaW5nLXNhcmFoLmdiXCJ9O1xuICB7bmFtZSA9IFwiU0hFRVAgSVQgVVBcIiAgICAgICA7IHBhdGggPSBcIi4vc2hlZXAtaXQtdXAuZ2JcIn07XG5dXG5cbmxldCBhbGVydCB2ID1cbiAgbGV0IGFsZXJ0ID0gSnYuZ2V0IEp2Lmdsb2JhbCBcImFsZXJ0XCIgaW5cbiAgaWdub3JlIEBAIEp2LmFwcGx5IGFsZXJ0IEp2Llt8IG9mX3N0cmluZyB2IHxdXG5cbmxldCBjb25zb2xlX2xvZyBzID0gQ29uc29sZS5sb2cgSnN0ci5bb2Zfc3RyaW5nIHNdXG5cbmxldCBmaW5kX2VsX2J5X2lkIGlkID0gRG9jdW1lbnQuZmluZF9lbF9ieV9pZCBHLmRvY3VtZW50IChKc3RyLnYgaWQpIHw+IE9wdGlvbi5nZXRcblxubGV0IGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmIgPVxuICBsZXQgZCA9IEMyZC5JbWFnZV9kYXRhLmRhdGEgaW1hZ2VfZGF0YSBpblxuICBmb3IgeSA9IDAgdG8gZ2JfaCAtIDEgZG9cbiAgICBmb3IgeCA9IDAgdG8gZ2JfdyAtIDEgZG9cbiAgICAgIGxldCBvZmYgPSA0ICogKHkgKiBnYl93ICsgeCkgaW5cbiAgICAgIG1hdGNoIGZiLih5KS4oeCkgd2l0aFxuICAgICAgfCBgV2hpdGUgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweEU1O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4RkI7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhGNDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgTGlnaHRfZ3JheSAtPlxuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiAgICApIDB4OTc7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMSkgMHhBRTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAyKSAweEI4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDMpIDB4RkY7XG4gICAgICB8IGBEYXJrX2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDYxO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4Njg7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHg3RDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgQmxhY2sgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDIyO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4MUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHgzMTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgIGRvbmVcbiAgZG9uZTtcbiAgQzJkLnB1dF9pbWFnZV9kYXRhIGN0eCBpbWFnZV9kYXRhIH54OjAgfnk6MFxuXG4oKiogTWFuYWdlcyBzdGF0ZSB0aGF0IG5lZWQgdG8gYmUgcmVzZXQgd2hlbiBsb2FkaW5nIGEgbmV3IHJvbSAqKVxubW9kdWxlIFN0YXRlID0gc3RydWN0XG4gIGxldCBydW5faWQgPSByZWYgTm9uZVxuICBsZXQga2V5X2Rvd25fbGlzdGVuZXIgPSByZWYgTm9uZVxuICBsZXQga2V5X3VwX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IHNldF9saXN0ZW5lciBkb3duIHVwID1cbiAgICBrZXlfZG93bl9saXN0ZW5lciA6PSBTb21lIGRvd247XG4gICAga2V5X3VwX2xpc3RlbmVyIDo9IFNvbWUgdXBcbiAgbGV0IGNsZWFyICgpID1cbiAgICBiZWdpbiBtYXRjaCAhcnVuX2lkIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIHRpbWVyX2lkIC0+XG4gICAgICAgIEcuc3RvcF90aW1lciB0aW1lcl9pZDtcbiAgICAgICAgRy5jYW5jZWxfYW5pbWF0aW9uX2ZyYW1lIHRpbWVyX2lkO1xuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X2Rvd25fbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleWRvd24gbGlzdGVyIEcudGFyZ2V0XG4gICAgZW5kO1xuICAgIGJlZ2luIG1hdGNoICFrZXlfdXBfbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleXVwIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZFxuZW5kXG5cbmxldCBzZXRfdXBfa2V5Ym9hcmQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5wcmVzcyB0IFN0YXJ0XG4gICAgfCBcIlNoaWZ0XCIgLT4gQy5wcmVzcyB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucHJlc3MgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5wcmVzcyB0IEFcbiAgICB8IFwid1wiICAgICAtPiBDLnByZXNzIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnByZXNzIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucHJlc3MgdCBEb3duXG4gICAgfCBcImRcIiAgICAgLT4gQy5wcmVzcyB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIGxldCBrZXlfdXBfbGlzdGVuZXIgZXYgPVxuICAgIGxldCBrZXlfZXYgPSBFdi5hc190eXBlIGV2IGluXG4gICAgbGV0IGtleV9uYW1lID0ga2V5X2V2IHw+IEV2LktleWJvYXJkLmtleSB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIG1hdGNoIGtleV9uYW1lIHdpdGhcbiAgICB8IFwiRW50ZXJcIiAtPiBDLnJlbGVhc2UgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucmVsZWFzZSB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucmVsZWFzZSB0IEJcbiAgICB8IFwia1wiICAgICAtPiBDLnJlbGVhc2UgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5yZWxlYXNlIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnJlbGVhc2UgdCBMZWZ0XG4gICAgfCBcInNcIiAgICAgLT4gQy5yZWxlYXNlIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucmVsZWFzZSB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIEV2Lmxpc3RlbiBFdi5rZXlkb3duIChrZXlfZG93bl9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIEV2Lmxpc3RlbiBFdi5rZXl1cCAoa2V5X3VwX2xpc3RlbmVyKSBHLnRhcmdldDtcbiAgU3RhdGUuc2V0X2xpc3RlbmVyIGtleV9kb3duX2xpc3RlbmVyIGtleV91cF9saXN0ZW5lclxuXG5sZXQgc2V0X3VwX2pveXBhZCAodHlwZSBhKSAobW9kdWxlIEMgOiBDYW1sYm95X2ludGYuUyB3aXRoIHR5cGUgdCA9IGEpICh0IDogYSkgPVxuICBsZXQgdXBfZWwsIGRvd25fZWwsIGxlZnRfZWwsIHJpZ2h0X2VsID1cbiAgICBmaW5kX2VsX2J5X2lkIFwidXBcIiwgZmluZF9lbF9ieV9pZCBcImRvd25cIiwgZmluZF9lbF9ieV9pZCBcImxlZnRcIiwgZmluZF9lbF9ieV9pZCBcInJpZ2h0XCIgaW5cbiAgbGV0IGFfZWwsIGJfZWwgPSBmaW5kX2VsX2J5X2lkIFwiYVwiLCBmaW5kX2VsX2J5X2lkIFwiYlwiIGluXG4gIGxldCBzdGFydF9lbCwgc2VsZWN0X2VsID0gZmluZF9lbF9ieV9pZCBcInN0YXJ0XCIsIGZpbmRfZWxfYnlfaWQgXCJzZWxlY3RcIiBpblxuICBsZXQgdmliZXJhdGUgbXMgPVxuICAgIGxldCBuYXZpZ2F0b3IgPSBHLm5hdmlnYXRvciB8PiBOYXZpZ2F0b3IudG9fanYgaW5cbiAgICBpZ25vcmUgQEAgSnYuY2FsbCBuYXZpZ2F0b3IgXCJ2aWJyYXRlXCIgSnYuW3wgb2ZfaW50IG1zIHxdXG4gIGluXG4gICgqIFRPRE86IHVubGlzdGVuIHRoZXNlIGxpc3RlbmVyIG9uIHJvbSBjaGFuZ2UgKilcbiAgbGV0IHByZXNzIGV2IHQga2V5ID0gRXYucHJldmVudF9kZWZhdWx0IGV2OyB2aWJlcmF0ZSAxMDsgQy5wcmVzcyB0IGtleSBpblxuICBsZXQgcmVsZWFzZSBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgQy5yZWxlYXNlIHQga2V5IGluXG4gIGxldCBsaXN0ZW5fb3BzID0gRXYubGlzdGVuX29wdHMgfmNhcHR1cmU6dHJ1ZSAoKSBpblxuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBVcCkgICAgIChFbC5hc190YXJnZXQgdXBfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBEb3duKSAgIChFbC5hc190YXJnZXQgZG93bl9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IExlZnQpICAgKEVsLmFzX3RhcmdldCBsZWZ0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgUmlnaHQpICAoRWwuYXNfdGFyZ2V0IHJpZ2h0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQSkgICAgICAoRWwuYXNfdGFyZ2V0IGFfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBCKSAgICAgIChFbC5hc190YXJnZXQgYl9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFN0YXJ0KSAgKEVsLmFzX3RhcmdldCBzdGFydF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFNlbGVjdCkgKEVsLmFzX3RhcmdldCBzZWxlY3RfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBVcCkgICAgIChFbC5hc190YXJnZXQgdXBfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBEb3duKSAgIChFbC5hc190YXJnZXQgZG93bl9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IExlZnQpICAgKEVsLmFzX3RhcmdldCBsZWZ0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgUmlnaHQpICAoRWwuYXNfdGFyZ2V0IHJpZ2h0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQSkgICAgICAoRWwuYXNfdGFyZ2V0IGFfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBCKSAgICAgIChFbC5hc190YXJnZXQgYl9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFN0YXJ0KSAgKEVsLmFzX3RhcmdldCBzdGFydF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFNlbGVjdCkgKEVsLmFzX3RhcmdldCBzZWxlY3RfZWwpXG5cbmxldCB0aHJvdHRsZWQgPSByZWYgdHJ1ZVxuXG5sZXQgcnVuX3JvbV9ieXRlcyBjdHggaW1hZ2VfZGF0YSByb21fYnl0ZXMgPVxuICBTdGF0ZS5jbGVhciAoKTtcbiAgbGV0IGNhcnRyaWRnZSA9IERldGVjdF9jYXJ0cmlkZ2UuZiB+cm9tX2J5dGVzIGluXG4gIGxldCBtb2R1bGUgQyA9IENhbWxib3kuTWFrZSh2YWwgY2FydHJpZGdlKSBpblxuICBsZXQgdCA9ICBDLmNyZWF0ZV93aXRoX3JvbSB+cHJpbnRfc2VyaWFsX3BvcnQ6dHJ1ZSB+cm9tX2J5dGVzIGluXG4gIHNldF91cF9rZXlib2FyZCAobW9kdWxlIEMpIHQ7XG4gIHNldF91cF9qb3lwYWQgKG1vZHVsZSBDKSB0O1xuICBsZXQgY250ID0gcmVmIDAgaW5cbiAgbGV0IHN0YXJ0X3RpbWUgPSByZWYgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSBpblxuICBsZXQgc2V0X2ZwcyBmcHMgPVxuICAgIGxldCBmcHNfc3RyID0gUHJpbnRmLnNwcmludGYgXCIlLjFmXCIgZnBzIGluXG4gICAgbGV0IGZwc19lbCA9IGZpbmRfZWxfYnlfaWQgXCJmcHNcIiBpblxuICAgIEVsLnNldF9jaGlsZHJlbiBmcHNfZWwgW0VsLnR4dCAoSnN0ci52IGZwc19zdHIpXVxuICBpblxuICBsZXQgcmVjIG1haW5fbG9vcCAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggQy5ydW5faW5zdHJ1Y3Rpb24gdCB3aXRoXG4gICAgICB8IEluX2ZyYW1lIC0+XG4gICAgICAgIG1haW5fbG9vcCAoKVxuICAgICAgfCBGcmFtZV9lbmRlZCBmYiAtPlxuICAgICAgICBpbmNyIGNudDtcbiAgICAgICAgaWYgIWNudCA9IDYwIHRoZW4gYmVnaW5cbiAgICAgICAgICBsZXQgZW5kX3RpbWUgPSBQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSBpblxuICAgICAgICAgIGxldCBzZWNfcGVyXzYwX2ZyYW1lID0gKGVuZF90aW1lIC0uICFzdGFydF90aW1lKSAvLiAxMDAwLiBpblxuICAgICAgICAgIGxldCBmcHMgPSA2MC4gLy4gIHNlY19wZXJfNjBfZnJhbWUgaW5cbiAgICAgICAgICBzdGFydF90aW1lIDo9IGVuZF90aW1lO1xuICAgICAgICAgIHNldF9mcHMgZnBzO1xuICAgICAgICAgIGNudCA6PSAwO1xuICAgICAgICBlbmQ7XG4gICAgICAgIGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmI7XG4gICAgICAgIGlmIG5vdCAhdGhyb3R0bGVkIHRoZW5cbiAgICAgICAgICBTdGF0ZS5ydW5faWQgOj0gU29tZSAoRy5zZXRfdGltZW91dCB+bXM6MCBtYWluX2xvb3ApXG4gICAgICAgIGVsc2VcbiAgICAgICAgICBTdGF0ZS5ydW5faWQgOj0gU29tZSAoRy5yZXF1ZXN0X2FuaW1hdGlvbl9mcmFtZSAoZnVuIF8gLT4gbWFpbl9sb29wICgpKSlcbiAgICBlbmQ7XG4gIGluXG4gIG1haW5fbG9vcCAoKVxuXG5sZXQgcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIHJvbV9ibG9iID1cbiAgbGV0KiByZXN1bHQgPSBCbG9iLmFycmF5X2J1ZmZlciByb21fYmxvYiBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIGJ1ZiAtPlxuICAgIGxldCByb21fYnl0ZXMgPVxuICAgICAgVGFycmF5Lm9mX2J1ZmZlciBVaW50OCBidWZcbiAgICAgIHw+IFRhcnJheS50b19iaWdhcnJheTFcbiAgICAgICgqIENvbnZlcnQgdWludDggYmlnYXJyYXkgdG8gY2hhciBiaWdhcnJheSAqKVxuICAgICAgfD4gT2JqLm1hZ2ljXG4gICAgaW5cbiAgICBGdXQucmV0dXJuIEBAIHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzXG4gIHwgRXJyb3IgZSAtPlxuICAgIEZ1dC5yZXR1cm4gQEAgQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKVxuXG5sZXQgb25fbG9hZF9yb20gY3R4IGltYWdlX2RhdGEgaW5wdXRfZWwgPVxuICBsZXQgZmlsZSA9IEVsLklucHV0LmZpbGVzIGlucHV0X2VsIHw+IExpc3QuaGQgaW5cbiAgbGV0IGJsb2IgPSBGaWxlLmFzX2Jsb2IgZmlsZSBpblxuICBGdXQuYXdhaXQgKHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSBibG9iKSAoZnVuICgpIC0+ICgpKVxuXG5sZXQgcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCA9XG4gIGxldCogcmVzdWx0ID0gRmV0Y2gudXJsIChKc3RyLnYgcm9tX3BhdGgpIGluXG4gIG1hdGNoIHJlc3VsdCB3aXRoXG4gIHwgT2sgcmVzcG9uc2UgLT5cbiAgICBsZXQgYm9keSA9IEZldGNoLlJlc3BvbnNlLmFzX2JvZHkgcmVzcG9uc2UgaW5cbiAgICBsZXQqIHJlc3VsdCA9IEZldGNoLkJvZHkuYmxvYiBib2R5IGluXG4gICAgYmVnaW4gbWF0Y2ggcmVzdWx0IHdpdGhcbiAgICAgIHwgT2sgYmxvYiAtPiBydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYlxuICAgICAgfCBFcnJvciBlICAtPiBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcbiAgICBlbmRcbiAgfCBFcnJvciBlICAtPiBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IHNldF91cF9yb21fc2VsZWN0b3IgY3R4IGltYWdlX2RhdGEgc2VsZWN0b3JfZWwgPVxuICByb21fb3B0aW9uc1xuICB8PiBMaXN0Lm1hcCAoZnVuIHJvbV9vcHRpb24gLT5cbiAgICAgIEVsLm9wdGlvblxuICAgICAgICB+YXQ6QXQuW3ZhbHVlIChKc3RyLnYgcm9tX29wdGlvbi5wYXRoKV1cbiAgICAgICAgW0VsLnR4dCcgcm9tX29wdGlvbi5uYW1lXSlcbiAgfD4gRWwuYXBwZW5kX2NoaWxkcmVuIHNlbGVjdG9yX2VsO1xuICBsZXQgb25fY2hhbmdlIF8gPVxuICAgIGxldCByb21fcGF0aCA9IEVsLnByb3AgKEVsLlByb3AudmFsdWUpIHNlbGVjdG9yX2VsIHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgRnV0LmF3YWl0IChydW5fc2VsZWN0ZWRfcm9tIGN0eCBpbWFnZV9kYXRhIHJvbV9wYXRoKSAoZnVuICgpIC0+ICgpKVxuICBpblxuICBFdi5saXN0ZW4gRXYuY2hhbmdlIG9uX2NoYW5nZSAoRWwuYXNfdGFyZ2V0IHNlbGVjdG9yX2VsKVxuXG5sZXQgc2V0X2RlZmF1bHRfdGhyb3R0bGVfdmFsIGNoZWNrYm94X2VsID1cbiAgbGV0IHVyaSA9IFdpbmRvdy5sb2NhdGlvbiBHLndpbmRvdyBpblxuICBsZXQgcGFyYW0gPVxuICAgIHVyaVxuICAgIHw+IFVyaS5xdWVyeVxuICAgIHw+IFVyaS5QYXJhbXMub2ZfanN0clxuICAgIHw+IFVyaS5QYXJhbXMuZmluZCBKc3RyLih2IFwidGhyb3R0bGVkXCIpXG4gIGluXG4gIGxldCBzZXRfdGhyb3R0bGVkX3ZhbCBiID1cbiAgICBFbC5zZXRfcHJvcCAoRWwuUHJvcC5jaGVja2VkKSBiIGNoZWNrYm94X2VsO1xuICAgIHRocm90dGxlZCA6PSBiXG4gIGluXG4gIG1hdGNoIHBhcmFtIHdpdGhcbiAgfCBTb21lIGpzdHIgLT5cbiAgICBiZWdpbiBtYXRjaCBKc3RyLnRvX3N0cmluZyBqc3RyIHdpdGhcbiAgICAgIHwgXCJmYWxzZVwiIC0+IHNldF90aHJvdHRsZWRfdmFsIGZhbHNlXG4gICAgICB8IF8gICAgICAtPiBzZXRfdGhyb3R0bGVkX3ZhbCB0cnVlXG4gICAgZW5kXG4gIHwgTm9uZSAtPiBzZXRfdGhyb3R0bGVkX3ZhbCB0cnVlXG5cbmxldCBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwgPVxuICBsZXQgY2hlY2tlZCA9IEVsLnByb3AgKEVsLlByb3AuY2hlY2tlZCkgY2hlY2tib3hfZWwgaW5cbiAgdGhyb3R0bGVkIDo9IGNoZWNrZWRcblxubGV0ICgpID1cbiAgKCogU2V0IHVwIGNhbnZhcyAqKVxuICBsZXQgY2FudmFzID0gZmluZF9lbF9ieV9pZCBcImNhbnZhc1wiIHw+IENhbnZhcy5vZl9lbCBpblxuICBsZXQgY3R4ID0gQzJkLmNyZWF0ZSBjYW52YXMgaW5cbiAgQzJkLnNjYWxlIGN0eCB+c3g6MS41IH5zeToxLjU7XG4gIGxldCBpbWFnZV9kYXRhID0gQzJkLmNyZWF0ZV9pbWFnZV9kYXRhIGN0eCB+dzpnYl93IH5oOmdiX2ggaW5cbiAgbGV0IGZiID0gQXJyYXkubWFrZV9tYXRyaXggZ2JfaCBnYl93IGBMaWdodF9ncmF5IGluXG4gIGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmI7XG4gICgqIFNldCB1cCB0aHJvdHRsZSBjaGVja2JveCAqKVxuICBsZXQgY2hlY2tib3hfZWwgPSBmaW5kX2VsX2J5X2lkIFwidGhyb3R0bGVcIiBpblxuICBzZXRfZGVmYXVsdF90aHJvdHRsZV92YWwgY2hlY2tib3hfZWw7XG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2NoZWNrYm94X2NoYW5nZSBjaGVja2JveF9lbCkgKEVsLmFzX3RhcmdldCBjaGVja2JveF9lbCk7XG4gICgqIFNldCB1cCBsb2FkIHJvbSBidXR0b24gKilcbiAgbGV0IGlucHV0X2VsID0gZmluZF9lbF9ieV9pZCBcImxvYWQtcm9tXCIgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSAoZnVuIF8gLT4gb25fbG9hZF9yb20gY3R4IGltYWdlX2RhdGEgaW5wdXRfZWwpIChFbC5hc190YXJnZXQgaW5wdXRfZWwpO1xuICAoKiBTZXQgdXAgcm9tIHNlbGVjdG9yICopXG4gIGxldCBzZWxlY3Rvcl9lbCA9IGZpbmRfZWxfYnlfaWQgXCJyb20tc2VsZWN0b3JcIiBpblxuICBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsO1xuICAoKiBMb2FkIGluaXRpYWwgcm9tICopXG4gIGxldCByb20gPSBMaXN0LmhkIHJvbV9vcHRpb25zIGluXG4gIGxldCBmdXQgPSBydW5fc2VsZWN0ZWRfcm9tIGN0eCBpbWFnZV9kYXRhIHJvbS5wYXRoIGluXG4gIEZ1dC5hd2FpdCBmdXQgKGZ1biAoKSAtPiAoKSlcbiJdfQ==
