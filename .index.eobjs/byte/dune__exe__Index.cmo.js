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
         caml_string_of_jsbytes("Retroid"),
         caml_string_of_jsbytes("./retroid.gb")],
        [0,
         [0,
          caml_string_of_jsbytes("Into The Blue"),
          caml_string_of_jsbytes("./into-the-blue.gb")],
         [0,
          [0,
           caml_string_of_jsbytes("Tobu Tobu Girl"),
           caml_string_of_jsbytes("./tobu.gb")],
          [0,
           [0,
            caml_string_of_jsbytes("Dreaming Sarah"),
            caml_string_of_jsbytes("./dreaming-sarah.gb")],
           [0,
            [0,
             caml_string_of_jsbytes("Rocket Man Demo"),
             caml_string_of_jsbytes("./rocket-man-demo.gb")],
            [0,
             [0,
              caml_string_of_jsbytes("SHEEP IT UP"),
              caml_string_of_jsbytes("./sheep-it-up.gb")],
             0]]]]]]],
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
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Option=global_data.Stdlib__Option,
     Stdlib_Array=global_data.Stdlib__Array,
     _b_=[0,[8,[0,0,0],0,[0,2],0],caml_string_of_jsbytes("%.2f")],
     _a_=[0,1],
     gb_w=160,
     gb_h=144;
    function alert(v)
     {var alert=Jv[12].alert;alert(caml_call1(Jv[23],v));return 0}
    function find_el_by_id(id)
     {var _$_=caml_call2(Brr[10][2],Brr[16][2],caml_jsstring_of_string(id));
      return caml_call1(Stdlib_Option[4],_$_)}
    function draw_framebuffer(ctx,image_data,fb)
     {var d=caml_call1(Brr_canvas[4][90][4],image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           match=caml_check_bound(caml_check_bound(fb,y)[1 + y],x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 97;
             d[off + 1 | 0] = 104;
             d[off + 2 | 0] = 125;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 229;
             d[off + 1 | 0] = 251;
             d[off + 2 | 0] = 244;
             d[off + 3 | 0] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             d[off + 1 | 0] = 174;
             d[off + 2 | 0] = 184;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 34;
             d[off + 1 | 0] = 30;
             d[off + 2 | 0] = 49;
             d[off + 3 | 0] = 255}
          var ___=x + 1 | 0;
          if(159 !== x){var x=___;continue}
          var _Z_=y + 1 | 0;
          if(143 !== y){var y=_Z_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _W_=run_id[1];
      if(_W_)
       {var timer_id=_W_[1];
        caml_call1(Brr[16][10],timer_id);
        caml_call1(Brr[16][12],timer_id)}
      var _X_=key_down_listener[1];
      if(_X_)
       {var lister=_X_[1];
        caml_call4(Brr[7][21],0,Brr[7][76],lister,Brr[16][6])}
      var _Y_=key_up_listener[1];
      if(_Y_)
       {var lister$0=_Y_[1];
        return caml_call4(Brr[7][21],0,Brr[7][77],lister$0,Brr[16][6])}
      return 0}
    var State=[0,run_id,key_down_listener,key_up_listener,set_listener,clear];
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
          return caml_string_notequal(key_name,cst_Enter)
                  ?caml_string_notequal(key_name,cst_Shift)
                    ?caml_string_notequal(key_name,cst_a)
                      ?caml_string_notequal(key_name,cst_d)
                        ?caml_string_notequal(key_name,cst_j)
                          ?caml_string_notequal(key_name,cst_k)
                            ?caml_string_notequal(key_name,cst_s)
                              ?caml_string_notequal(key_name,cst_w)?0:caml_call2(C[5],t,1)
                              :caml_call2(C[5],t,0)
                            :caml_call2(C[5],t,7)
                          :caml_call2(C[5],t,6)
                        :caml_call2(C[5],t,3)
                      :caml_call2(C[5],t,2)
                    :caml_call2(C[5],t,5)
                  :caml_call2(C[5],t,4)}
        function key_up_listener(ev)
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
          return caml_string_notequal(key_name,cst_Enter$0)
                  ?caml_string_notequal(key_name,cst_Shift$0)
                    ?caml_string_notequal(key_name,cst_a$0)
                      ?caml_string_notequal(key_name,cst_d$0)
                        ?caml_string_notequal(key_name,cst_j$0)
                          ?caml_string_notequal(key_name,cst_k$0)
                            ?caml_string_notequal(key_name,cst_s$0)
                              ?caml_string_notequal(key_name,cst_w$0)
                                ?0
                                :caml_call2(C[6],t,1)
                              :caml_call2(C[6],t,0)
                            :caml_call2(C[6],t,7)
                          :caml_call2(C[6],t,6)
                        :caml_call2(C[6],t,3)
                      :caml_call2(C[6],t,2)
                    :caml_call2(C[6],t,5)
                  :caml_call2(C[6],t,4)}
        caml_call4(Brr[7][20],0,Brr[7][76],key_down_listener,Brr[16][6]);
        caml_call4(Brr[7][20],0,Brr[7][77],key_up_listener,Brr[16][6]);
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
        function press(ev,t,key)
         {caml_call1(Brr[7][13],ev);return caml_call2(C[5],t,key)}
        function release(ev,t,key)
         {caml_call1(Brr[7][13],ev);return caml_call2(C[6],t,key)}
        var listen_ops=caml_call4(Brr[7][19],_a_,0,0,0);
        function _G_(ev){return press(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_G_,up_el);
        function _H_(ev){return press(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_H_,down_el);
        function _I_(ev){return press(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_I_,left_el);
        function _J_(ev){return press(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_J_,right_el);
        function _K_(ev){return press(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_K_,a_el);
        function _L_(ev){return press(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_L_,b_el);
        function _M_(ev){return press(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_M_,start_el);
        function _N_(ev){return press(ev,t,5)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_N_,select_el);
        function _O_(ev){return release(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_O_,up_el);
        function _P_(ev){return release(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_P_,down_el);
        function _Q_(ev){return release(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_Q_,left_el);
        function _R_(ev){return release(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_R_,right_el);
        function _S_(ev){return release(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_S_,a_el);
        function _T_(ev){return release(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_T_,b_el);
        function _U_(ev){return release(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_U_,start_el);
        function _V_(ev){return release(ev,t,5)}
        return caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_V_,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {caml_call1(State[5],0);
      var
       cartridge=caml_call1(Camlboy_lib_Detect_cartridge[1],rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       t=caml_call2(C[3],1,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var cnt=[0,0],start_time=[0,caml_call1(Brr[15][9],Brr[16][4])];
      function main_loop(param)
       {for(;;)
         {var match=caml_call1(C[4],t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               end_time=caml_call1(Brr[15][9],Brr[16][4]),
               sec_per_60_frame=(end_time - start_time[1]) / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              var
               fps_str=caml_call2(Stdlib_Printf[4],_b_,fps),
               fps_el=find_el_by_id(cst_fps),
               _C_=
                [0,caml_call2(Brr[9][2],0,caml_jsstring_of_string(fps_str)),0];
              caml_call2(Brr[9][18],fps_el,_C_);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var
               _D_=function(param){return main_loop(0)},
               _E_=[0,caml_call1(Brr[16][11],_D_)];
              State[1][1] = _E_;
              return 0}
            var _F_=[0,caml_call2(Brr[16][8],0,main_loop)];
            State[1][1] = _F_;
            return 0}
          continue}}
      return main_loop(0)}
    function run_rom_blob(ctx,image_data,rom_blob)
     {function _x_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           rom_bytes=
            runtime.caml_ba_from_typed_array(caml_call4(Brr[1][5],3,0,0,buf)),
           _z_=run_rom_bytes(ctx,image_data,rom_bytes);
          return caml_call1(Fut[3],_z_)}
        var
         e=result[1],
         _A_=[0,caml_call1(Jv[30][4],e),0],
         _B_=caml_call1(Brr[12][9],_A_);
        return caml_call1(Fut[3],_B_)}
      var _y_=caml_call1(Brr[2][8],rom_blob);
      return caml_call2(Fut[15][1],_y_,_x_)}
    function on_load_rom(ctx,image_data,input_el)
     {var
       _u_=caml_call1(Brr[9][56][1],input_el),
       file=caml_call1(Stdlib_List[5],_u_);
      function _v_(param){return 0}
      var _w_=run_rom_blob(ctx,image_data,file);
      return caml_call2(Fut[2],_w_,_v_)}
    function run_selected_rom(ctx,image_data,rom_path)
     {function _m_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _o_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(ctx,image_data,blob)}
              var
               e=result[1],
               _s_=[0,caml_call1(Jv[30][4],e),0],
               _t_=caml_call1(Brr[12][9],_s_);
              return caml_call1(Fut[3],_t_)},
           _p_=caml_call1(Brr_io[3][1][9],response);
          return caml_call2(Fut[15][1],_p_,_o_)}
        var
         e=result[1],
         _q_=[0,caml_call1(Jv[30][4],e),0],
         _r_=caml_call1(Brr[12][9],_q_);
        return caml_call1(Fut[3],_r_)}
      var _n_=caml_call2(Brr_io[3][7],0,caml_jsstring_of_string(rom_path));
      return caml_call2(Fut[15][1],_n_,_m_)}
    function set_up_rom_selector(ctx,image_data,selector_el)
     {function _g_(rom_option)
       {var
         _k_=[0,caml_call2(Brr[9][3],0,rom_option[1]),0],
         _l_=
          [0,
           [0,caml_call1(Brr[8][37],caml_jsstring_of_string(rom_option[2])),0]];
        return caml_call3(Brr[9][127],0,_l_,_k_)}
      var _h_=caml_call1(caml_call1(Stdlib_List[19],_g_),rom_options);
      caml_call1(caml_call1(Brr[9][20],selector_el),_h_);
      function on_change(param)
       {var
         rom_path=
          caml_string_of_jsstring
           (caml_call2(Brr[9][26],Brr[9][25][10],selector_el));
        function _i_(param){return 0}
        var _j_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_j_,_i_)}
      return caml_call4(Brr[7][20],0,Brr[7][43],on_change,selector_el)}
    function on_checkbox_change(checkbox_el)
     {var checked=caml_call2(Brr[9][26],Brr[9][25][5],checkbox_el);
      throttled[1] = checked;
      return 0}
    var
     _c_=find_el_by_id(cst_canvas),
     canvas=caml_call1(Brr_canvas[3][2],_c_),
     ctx=caml_call2(Brr_canvas[4][15],0,canvas);
    caml_call3(Brr_canvas[4][36],ctx,1.5,1.5);
    var
     image_data=caml_call3(Brr_canvas[4][91],ctx,gb_w,gb_h),
     fb=caml_call3(Stdlib_Array[3],gb_h,gb_w,-603547828);
    draw_framebuffer(ctx,image_data,fb);
    var checkbox_el=find_el_by_id(cst_throttle);
    function _d_(param){return on_checkbox_change(checkbox_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_d_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _e_(param){return on_load_rom(ctx,image_data,input_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_e_,input_el);
    var selector_el=find_el_by_id(cst_rom_selector);
    set_up_rom_selector(ctx,image_data,selector_el);
    var
     rom=caml_call1(Stdlib_List[5],rom_options),
     fut=run_selected_rom(ctx,image_data,rom[2]);
    function _f_(param){return 0}
    caml_call2(Fut[2],fut,_f_);
    var
     Dune_exe_Index=
      [0,
       gb_w,
       gb_h,
       rom_options,
       alert,
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
       on_checkbox_change];
    runtime.caml_register_global(48,Dune_exe_Index,"Dune__exe__Index");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwiZmluZF9lbF9ieV9pZCIsImlkIiwiZHJhd19mcmFtZWJ1ZmZlciIsImN0eCIsImltYWdlX2RhdGEiLCJmYiIsImQiLCJ5IiwieCIsIm9mZiIsInJ1bl9pZCIsImtleV9kb3duX2xpc3RlbmVyIiwia2V5X3VwX2xpc3RlbmVyIiwic2V0X2xpc3RlbmVyIiwiZG93biIsInVwIiwiY2xlYXIiLCJ0aW1lcl9pZCIsImxpc3RlciIsImxpc3RlciQwIiwic2V0X3VwX2tleWJvYXJkIiwiQyIsInQiLCJldiIsImtleV9uYW1lIiwic2V0X3VwX2pveXBhZCIsInJpZ2h0X2VsIiwibGVmdF9lbCIsImRvd25fZWwiLCJ1cF9lbCIsImJfZWwiLCJhX2VsIiwic2VsZWN0X2VsIiwic3RhcnRfZWwiLCJwcmVzcyIsImtleSIsInJlbGVhc2UiLCJsaXN0ZW5fb3BzIiwidGhyb3R0bGVkIiwicnVuX3JvbV9ieXRlcyIsInJvbV9ieXRlcyIsImNhcnRyaWRnZSIsImNudCIsInN0YXJ0X3RpbWUiLCJtYWluX2xvb3AiLCJlbmRfdGltZSIsInNlY19wZXJfNjBfZnJhbWUiLCJmcHMiLCJmcHNfc3RyIiwiZnBzX2VsIiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwib25fbG9hZF9yb20iLCJpbnB1dF9lbCIsImZpbGUiLCJydW5fc2VsZWN0ZWRfcm9tIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJzZXRfdXBfcm9tX3NlbGVjdG9yIiwic2VsZWN0b3JfZWwiLCJyb21fb3B0aW9uIiwib25fY2hhbmdlIiwib25fY2hlY2tib3hfY2hhbmdlIiwiY2hlY2tib3hfZWwiLCJjaGVja2VkIiwiY2FudmFzIiwicm9tIiwiZnV0Il0sInNvdXJjZXMiOlsiL2hvbWUvcnVubmVyL3dvcmsvQ0FNTEJPWS9DQU1MQk9ZL19idWlsZC9kZWZhdWx0L2Jpbi93ZWIvaW5kZXgubWwiXSwibWFwcGluZ3MiOiI7O0k7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBV0lBOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQUpBQztLQUNBQzthQWFBQyxNQUFNQztNQUNJLElBQVJELG1CQUNNLE1BQXFCLGtCQUZ2QkMsSUFFRSxRQUFtQzthQUUzQ0MsY0FBY0M7TUFBSyx5Q0FBa0Msd0JBQXZDQTtNQUFLLHVDQUEyRDthQUU5RUMsaUJBQWlCQyxJQUFJQyxXQUFXQztNQUMxQixzQ0FEZUQsWUFFdkJHOztNQUNFOztRQUNFOztxQkFGSkEsZUFDRUM7V0FFYyx1QkFBTixpQkFMd0JILEdBRWxDRSxVQUNFQztVQUVjOzthQVlWLEVBYkVDO2FBY0YsRUFkRUE7YUFlRixFQWZFQTthQWdCRixFQWhCRUE7O2FBR0YsRUFIRUE7YUFJRixFQUpFQTthQUtGLEVBTEVBO2FBTUYsRUFORUE7OzthQVFGLEVBUkVBO2FBU0YsRUFURUE7YUFVRixFQVZFQTthQVdGLEVBWEVBOzthQWtCRixFQWxCRUE7YUFtQkYsRUFuQkVBO2FBb0JGLEVBcEJFQTthQXFCRixFQXJCRUE7VUFBSixRQURGRDs7VUFDRSxRQUZKRDs7VUEwQkEsb0NBNUJtQkosSUFBSUMsaUJBNEJvQjtRQUl2Q00sYUFDQUMsd0JBQ0FDO2FBQ0FDLGFBQWFDLEtBQUtDO01BQ3BCLDBCQURlRCxNQUNmLHdCQURvQkMsSUFDcEIsUUFDMEI7YUFDeEJDO01BQ0YsUUFQRU47TUFPRjtRQUdJLElBREtPO1FBQ0wsdUJBREtBO1FBRUwsdUJBRktBO01BRlQsUUFORU47TUFZRjtRQUVtQixJQUFWTztRQUFVLG1DQUFWQTtNQVJULFFBTEVOO01BZUY7WUFFU087O01BREcsUUFFVDtpQkFwQkRULE9BQ0FDLGtCQUNBQyxnQkFDQUMsYUFHQUc7YUFpQkZJLGdCQUFpQ0M7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OztvQ0FBTSx3QkFGSEE7UUFFSCx3Q0FDaUI7TUFBQyxtQkFIN0IsZ0NBMU1EckU7TUE4TStCLFdBQTlCLHNCQU5rQ29FO01BTUosU0FDN0JFO1FBQ2dEO1NBQTlDTjtVQUE4QztZQUFuQyxxQ0FSb0JJO1FBUWUsb0JBQ2MsUUFBRTtRQUF4RCx5QkFUVTVELElBQUlDLFdBUXBCdUQ7UUFDTSxpQ0FBeUQ7TUFIcEMsMENBQzdCTSxVQVBpQ0YsWUFXbUI7YUFFdERHLG1CQUFtQkM7TUFDUCxJQUFWQyxRQUFVLG9DQURPRDtNQUNQLGVBQVZDO01BQVUsUUFDTTtJQUlQOzs7S0FDSCxtQ0FETkM7SUFFSiw2QkFESWxFO0lBRFM7S0FHSSx3Q0FGYkEsSUFoT0ZQLEtBQ0FDO0tBa09PLDhCQWxPUEEsS0FEQUQ7SUFvT0YsaUJBSklPLElBRUFDLFdBQ0FDO0lBSlMsSUFPVDhELFlBQWM7d0JBQ1ksMEJBRDFCQSxZQUN3RDtJQUE1RCx1Q0FESUE7SUFHVyxJQUFYWCxTQUFXO3dCQUNlLG1CQVYxQnJELElBRUFDLFdBT0FvRCxTQUM2RDtJQUFqRSx1Q0FESUE7SUFHYyxJQUFkTyxZQUFjO0lBQ2xCLG9CQWJJNUQsSUFFQUMsV0FVQTJEO0lBQWM7S0FHUiw4QkEzT1JwRTtLQTRPUSxxQkFoQk5RLElBRUFDLFdBYUFrRTtJQUNNLG9CQUNlLFFBQUU7SUFBM0Isa0JBRElDO0lBQ0o7OztPQWpQRTNFO09BQ0FDO09BR0FGO09BVUFHO09BSUFFO09BRUFFOztPQXVEQWtCO09BaUNBSztPQTBCQWE7T0FFQUM7T0FxQ0FXO09BY0FLO09BS0FHO09BWUFJO09BYUFJO0lBd0JGO1UiLCJzb3VyY2VzQ29udGVudCI6WyJvcGVuIENhbWxib3lfbGliXG5vcGVuIEJyclxub3BlbiBCcnJfY2FudmFzXG5vcGVuIEJycl9pb1xub3BlbiBGdXQuU3ludGF4XG5cblxubGV0IGdiX3cgPSAxNjBcbmxldCBnYl9oID0gMTQ0XG5cbnR5cGUgcm9tX29wdGlvbiA9IHtuYW1lIDogc3RyaW5nOyBwYXRoIDogc3RyaW5nfVxubGV0IHJvbV9vcHRpb25zID0gW1xuICB7bmFtZSA9IFwiVGhlIEJvdW5jaW5nIEJhbGxcIiA7IHBhdGggPSBcIi4vdGhlLWJvdW5jaW5nLWJhbGwuZ2JcIn07XG4gIHtuYW1lID0gXCJSZXRyb2lkXCIgICA7IHBhdGggPSBcIi4vcmV0cm9pZC5nYlwifTtcbiAge25hbWUgPSBcIkludG8gVGhlIEJsdWVcIiAgIDsgcGF0aCA9IFwiLi9pbnRvLXRoZS1ibHVlLmdiXCJ9O1xuICB7bmFtZSA9IFwiVG9idSBUb2J1IEdpcmxcIiAgICA7IHBhdGggPSBcIi4vdG9idS5nYlwifTtcbiAge25hbWUgPSBcIkRyZWFtaW5nIFNhcmFoXCIgICAgOyBwYXRoID0gXCIuL2RyZWFtaW5nLXNhcmFoLmdiXCJ9O1xuICB7bmFtZSA9IFwiUm9ja2V0IE1hbiBEZW1vXCIgICA7IHBhdGggPSBcIi4vcm9ja2V0LW1hbi1kZW1vLmdiXCJ9O1xuICB7bmFtZSA9IFwiU0hFRVAgSVQgVVBcIiAgICAgICA7IHBhdGggPSBcIi4vc2hlZXAtaXQtdXAuZ2JcIn07XG5dXG5cbmxldCBhbGVydCB2ID1cbiAgbGV0IGFsZXJ0ID0gSnYuZ2V0IEp2Lmdsb2JhbCBcImFsZXJ0XCIgaW5cbiAgaWdub3JlIEBAIEp2LmFwcGx5IGFsZXJ0IEp2Llt8IG9mX3N0cmluZyB2IHxdXG5cbmxldCBmaW5kX2VsX2J5X2lkIGlkID0gRG9jdW1lbnQuZmluZF9lbF9ieV9pZCBHLmRvY3VtZW50IChKc3RyLnYgaWQpIHw+IE9wdGlvbi5nZXRcblxubGV0IGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmIgPVxuICBsZXQgZCA9IEMyZC5JbWFnZV9kYXRhLmRhdGEgaW1hZ2VfZGF0YSBpblxuICBmb3IgeSA9IDAgdG8gZ2JfaCAtIDEgZG9cbiAgICBmb3IgeCA9IDAgdG8gZ2JfdyAtIDEgZG9cbiAgICAgIGxldCBvZmYgPSA0ICogKHkgKiBnYl93ICsgeCkgaW5cbiAgICAgIG1hdGNoIGZiLih5KS4oeCkgd2l0aFxuICAgICAgfCBgV2hpdGUgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweEU1O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4RkI7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhGNDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgTGlnaHRfZ3JheSAtPlxuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiAgICApIDB4OTc7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMSkgMHhBRTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAyKSAweEI4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDMpIDB4RkY7XG4gICAgICB8IGBEYXJrX2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDYxO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4Njg7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHg3RDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgQmxhY2sgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDIyO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4MUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHgzMTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgIGRvbmVcbiAgZG9uZTtcbiAgQzJkLnB1dF9pbWFnZV9kYXRhIGN0eCBpbWFnZV9kYXRhIH54OjAgfnk6MFxuXG4oKiogTWFuYWdlcyBzdGF0ZSB0aGF0IG5lZWQgdG8gYmUgcmVzZXQgd2hlbiBsb2FkaW5nIGEgbmV3IHJvbSAqKVxubW9kdWxlIFN0YXRlID0gc3RydWN0XG4gIGxldCBydW5faWQgPSByZWYgTm9uZVxuICBsZXQga2V5X2Rvd25fbGlzdGVuZXIgPSByZWYgTm9uZVxuICBsZXQga2V5X3VwX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IHNldF9saXN0ZW5lciBkb3duIHVwID1cbiAgICBrZXlfZG93bl9saXN0ZW5lciA6PSBTb21lIGRvd247XG4gICAga2V5X3VwX2xpc3RlbmVyIDo9IFNvbWUgdXBcbiAgbGV0IGNsZWFyICgpID1cbiAgICBiZWdpbiBtYXRjaCAhcnVuX2lkIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIHRpbWVyX2lkIC0+XG4gICAgICAgIEcuc3RvcF90aW1lciB0aW1lcl9pZDtcbiAgICAgICAgRy5jYW5jZWxfYW5pbWF0aW9uX2ZyYW1lIHRpbWVyX2lkO1xuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X2Rvd25fbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleWRvd24gbGlzdGVyIEcudGFyZ2V0XG4gICAgZW5kO1xuICAgIGJlZ2luIG1hdGNoICFrZXlfdXBfbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleXVwIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZFxuZW5kXG5cbmxldCBzZXRfdXBfa2V5Ym9hcmQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5wcmVzcyB0IFN0YXJ0XG4gICAgfCBcIlNoaWZ0XCIgLT4gQy5wcmVzcyB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucHJlc3MgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5wcmVzcyB0IEFcbiAgICB8IFwid1wiICAgICAtPiBDLnByZXNzIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnByZXNzIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucHJlc3MgdCBEb3duXG4gICAgfCBcImRcIiAgICAgLT4gQy5wcmVzcyB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIGxldCBrZXlfdXBfbGlzdGVuZXIgZXYgPVxuICAgIGxldCBrZXlfZXYgPSBFdi5hc190eXBlIGV2IGluXG4gICAgbGV0IGtleV9uYW1lID0ga2V5X2V2IHw+IEV2LktleWJvYXJkLmtleSB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIG1hdGNoIGtleV9uYW1lIHdpdGhcbiAgICB8IFwiRW50ZXJcIiAtPiBDLnJlbGVhc2UgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucmVsZWFzZSB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucmVsZWFzZSB0IEJcbiAgICB8IFwia1wiICAgICAtPiBDLnJlbGVhc2UgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5yZWxlYXNlIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnJlbGVhc2UgdCBMZWZ0XG4gICAgfCBcInNcIiAgICAgLT4gQy5yZWxlYXNlIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucmVsZWFzZSB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIEV2Lmxpc3RlbiBFdi5rZXlkb3duIChrZXlfZG93bl9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIEV2Lmxpc3RlbiBFdi5rZXl1cCAoa2V5X3VwX2xpc3RlbmVyKSBHLnRhcmdldDtcbiAgU3RhdGUuc2V0X2xpc3RlbmVyIGtleV9kb3duX2xpc3RlbmVyIGtleV91cF9saXN0ZW5lclxuXG5sZXQgc2V0X3VwX2pveXBhZCAodHlwZSBhKSAobW9kdWxlIEMgOiBDYW1sYm95X2ludGYuUyB3aXRoIHR5cGUgdCA9IGEpICh0IDogYSkgPVxuICBsZXQgdXBfZWwsIGRvd25fZWwsIGxlZnRfZWwsIHJpZ2h0X2VsID1cbiAgICBmaW5kX2VsX2J5X2lkIFwidXBcIiwgZmluZF9lbF9ieV9pZCBcImRvd25cIiwgZmluZF9lbF9ieV9pZCBcImxlZnRcIiwgZmluZF9lbF9ieV9pZCBcInJpZ2h0XCIgaW5cbiAgbGV0IGFfZWwsIGJfZWwgPSBmaW5kX2VsX2J5X2lkIFwiYVwiLCBmaW5kX2VsX2J5X2lkIFwiYlwiIGluXG4gIGxldCBzdGFydF9lbCwgc2VsZWN0X2VsID0gZmluZF9lbF9ieV9pZCBcInN0YXJ0XCIsIGZpbmRfZWxfYnlfaWQgXCJzZWxlY3RcIiBpblxuICAoKiBUT0RPOiB1bmxpc3RlbiB0aGVzZSBsaXN0ZW5lciB3aGVuIHJvbSBjaGFuZ2UgKilcbiAgbGV0IHByZXNzIGV2IHQga2V5ID0gRXYucHJldmVudF9kZWZhdWx0IGV2OyBDLnByZXNzIHQga2V5IGluXG4gIGxldCByZWxlYXNlIGV2IHQga2V5ID0gRXYucHJldmVudF9kZWZhdWx0IGV2OyBDLnJlbGVhc2UgdCBrZXkgaW5cbiAgbGV0IGxpc3Rlbl9vcHMgPSBFdi5saXN0ZW5fb3B0cyB+Y2FwdHVyZTp0cnVlICgpIGluXG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVyZG93biB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBVcCkgICAgIChFbC5hc190YXJnZXQgdXBfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgTGVmdCkgICAoRWwuYXNfdGFyZ2V0IGxlZnRfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgUmlnaHQpICAoRWwuYXNfdGFyZ2V0IHJpZ2h0X2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJkb3duIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJkb3duIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEIpICAgICAgKEVsLmFzX3RhcmdldCBiX2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJkb3duIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFN0YXJ0KSAgKEVsLmFzX3RhcmdldCBzdGFydF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVyZG93biB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJsZWF2ZSB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFVwKSAgICAgKEVsLmFzX3RhcmdldCB1cF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBEb3duKSAgIChFbC5hc190YXJnZXQgZG93bl9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBSaWdodCkgIChFbC5hc190YXJnZXQgcmlnaHRfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmxlYXZlIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQSkgICAgICAoRWwuYXNfdGFyZ2V0IGFfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmxlYXZlIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmxlYXZlIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgU3RhcnQpICAoRWwuYXNfdGFyZ2V0IHN0YXJ0X2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJsZWF2ZSB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFNlbGVjdCkgKEVsLmFzX3RhcmdldCBzZWxlY3RfZWwpXG5cbmxldCB0aHJvdHRsZWQgPSByZWYgdHJ1ZVxuXG5sZXQgcnVuX3JvbV9ieXRlcyBjdHggaW1hZ2VfZGF0YSByb21fYnl0ZXMgPVxuICBTdGF0ZS5jbGVhciAoKTtcbiAgbGV0IGNhcnRyaWRnZSA9IERldGVjdF9jYXJ0cmlkZ2UuZiB+cm9tX2J5dGVzIGluXG4gIGxldCBtb2R1bGUgQyA9IENhbWxib3kuTWFrZSh2YWwgY2FydHJpZGdlKSBpblxuICBsZXQgdCA9ICBDLmNyZWF0ZV93aXRoX3JvbSB+cHJpbnRfc2VyaWFsX3BvcnQ6dHJ1ZSB+cm9tX2J5dGVzIGluXG4gIHNldF91cF9rZXlib2FyZCAobW9kdWxlIEMpIHQ7XG4gIHNldF91cF9qb3lwYWQgKG1vZHVsZSBDKSB0O1xuICBsZXQgY250ID0gcmVmIDAgaW5cbiAgbGV0IHN0YXJ0X3RpbWUgPSByZWYgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSBpblxuICBsZXQgc2V0X2ZwcyBmcHMgPVxuICAgIGxldCBmcHNfc3RyID0gUHJpbnRmLnNwcmludGYgXCIlLjJmXCIgZnBzIGluXG4gICAgbGV0IGZwc19lbCA9IGZpbmRfZWxfYnlfaWQgXCJmcHNcIiBpblxuICAgIEVsLnNldF9jaGlsZHJlbiBmcHNfZWwgW0VsLnR4dCAoSnN0ci52IGZwc19zdHIpXVxuICBpblxuICBsZXQgcmVjIG1haW5fbG9vcCAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggQy5ydW5faW5zdHJ1Y3Rpb24gdCB3aXRoXG4gICAgICB8IEluX2ZyYW1lIC0+XG4gICAgICAgIG1haW5fbG9vcCAoKVxuICAgICAgfCBGcmFtZV9lbmRlZCBmYiAtPlxuICAgICAgICBpbmNyIGNudDtcbiAgICAgICAgaWYgIWNudCA9IDYwIHRoZW4gYmVnaW5cbiAgICAgICAgICBsZXQgZW5kX3RpbWUgPSBQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSBpblxuICAgICAgICAgIGxldCBzZWNfcGVyXzYwX2ZyYW1lID0gKGVuZF90aW1lIC0uICFzdGFydF90aW1lKSAvLiAxMDAwLiBpblxuICAgICAgICAgIGxldCBmcHMgPSA2MC4gLy4gIHNlY19wZXJfNjBfZnJhbWUgaW5cbiAgICAgICAgICBzdGFydF90aW1lIDo9IGVuZF90aW1lO1xuICAgICAgICAgIHNldF9mcHMgZnBzO1xuICAgICAgICAgIGNudCA6PSAwO1xuICAgICAgICBlbmQ7XG4gICAgICAgIGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmI7XG4gICAgICAgIGlmIG5vdCAhdGhyb3R0bGVkIHRoZW5cbiAgICAgICAgICBTdGF0ZS5ydW5faWQgOj0gU29tZSAoRy5zZXRfdGltZW91dCB+bXM6MCBtYWluX2xvb3ApXG4gICAgICAgIGVsc2VcbiAgICAgICAgICBTdGF0ZS5ydW5faWQgOj0gU29tZSAoRy5yZXF1ZXN0X2FuaW1hdGlvbl9mcmFtZSAoZnVuIF8gLT4gbWFpbl9sb29wICgpKSlcbiAgICBlbmQ7XG4gIGluXG4gIG1haW5fbG9vcCAoKVxuXG5sZXQgcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIHJvbV9ibG9iID1cbiAgbGV0KiByZXN1bHQgPSBCbG9iLmFycmF5X2J1ZmZlciByb21fYmxvYiBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIGJ1ZiAtPlxuICAgIGxldCByb21fYnl0ZXMgPVxuICAgICAgVGFycmF5Lm9mX2J1ZmZlciBVaW50OCBidWZcbiAgICAgIHw+IFRhcnJheS50b19iaWdhcnJheTFcbiAgICAgICgqIENvbnZlcnQgdWludDggYmlnYXJyYXkgdG8gY2hhciBiaWdhcnJheSAqKVxuICAgICAgfD4gT2JqLm1hZ2ljXG4gICAgaW5cbiAgICBGdXQucmV0dXJuIEBAIHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzXG4gIHwgRXJyb3IgZSAtPlxuICAgIEZ1dC5yZXR1cm4gQEAgQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKVxuXG5sZXQgb25fbG9hZF9yb20gY3R4IGltYWdlX2RhdGEgaW5wdXRfZWwgPVxuICBsZXQgZmlsZSA9IEVsLklucHV0LmZpbGVzIGlucHV0X2VsIHw+IExpc3QuaGQgaW5cbiAgbGV0IGJsb2IgPSBGaWxlLmFzX2Jsb2IgZmlsZSBpblxuICBGdXQuYXdhaXQgKHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSBibG9iKSAoZnVuICgpIC0+ICgpKVxuXG5sZXQgcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCA9XG4gIGxldCogcmVzdWx0ID0gRmV0Y2gudXJsIChKc3RyLnYgcm9tX3BhdGgpIGluXG4gIG1hdGNoIHJlc3VsdCB3aXRoXG4gIHwgT2sgcmVzcG9uc2UgLT5cbiAgICBsZXQgYm9keSA9IEZldGNoLlJlc3BvbnNlLmFzX2JvZHkgcmVzcG9uc2UgaW5cbiAgICBsZXQqIHJlc3VsdCA9IEZldGNoLkJvZHkuYmxvYiBib2R5IGluXG4gICAgYmVnaW4gbWF0Y2ggcmVzdWx0IHdpdGhcbiAgICAgIHwgT2sgYmxvYiAtPiBydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYlxuICAgICAgfCBFcnJvciBlICAtPiBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcbiAgICBlbmRcbiAgfCBFcnJvciBlICAtPiBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IHNldF91cF9yb21fc2VsZWN0b3IgY3R4IGltYWdlX2RhdGEgc2VsZWN0b3JfZWwgPVxuICByb21fb3B0aW9uc1xuICB8PiBMaXN0Lm1hcCAoZnVuIHJvbV9vcHRpb24gLT5cbiAgICAgIEVsLm9wdGlvblxuICAgICAgICB+YXQ6QXQuW3ZhbHVlIChKc3RyLnYgcm9tX29wdGlvbi5wYXRoKV1cbiAgICAgICAgW0VsLnR4dCcgcm9tX29wdGlvbi5uYW1lXSlcbiAgfD4gRWwuYXBwZW5kX2NoaWxkcmVuIHNlbGVjdG9yX2VsO1xuICBsZXQgb25fY2hhbmdlIF8gPVxuICAgIGxldCByb21fcGF0aCA9IEVsLnByb3AgKEVsLlByb3AudmFsdWUpIHNlbGVjdG9yX2VsIHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgRnV0LmF3YWl0IChydW5fc2VsZWN0ZWRfcm9tIGN0eCBpbWFnZV9kYXRhIHJvbV9wYXRoKSAoZnVuICgpIC0+ICgpKVxuICBpblxuICBFdi5saXN0ZW4gRXYuY2hhbmdlIG9uX2NoYW5nZSAoRWwuYXNfdGFyZ2V0IHNlbGVjdG9yX2VsKVxuXG5sZXQgb25fY2hlY2tib3hfY2hhbmdlIGNoZWNrYm94X2VsID1cbiAgbGV0IGNoZWNrZWQgPSBFbC5wcm9wIChFbC5Qcm9wLmNoZWNrZWQpIGNoZWNrYm94X2VsIGluXG4gIHRocm90dGxlZCA6PSBjaGVja2VkXG5cbmxldCAoKSA9XG4gICgqIFNldCB1cCBjYW52YXMgKilcbiAgbGV0IGNhbnZhcyA9IGZpbmRfZWxfYnlfaWQgXCJjYW52YXNcIiB8PiBDYW52YXMub2ZfZWwgaW5cbiAgbGV0IGN0eCA9IEMyZC5jcmVhdGUgY2FudmFzIGluXG4gIEMyZC5zY2FsZSBjdHggfnN4OjEuNSB+c3k6MS41O1xuICBsZXQgaW1hZ2VfZGF0YSA9IEMyZC5jcmVhdGVfaW1hZ2VfZGF0YSBjdHggfnc6Z2JfdyB+aDpnYl9oIGluXG4gIGxldCBmYiA9IEFycmF5Lm1ha2VfbWF0cml4IGdiX2ggZ2JfdyBgTGlnaHRfZ3JheSBpblxuICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAoKiBTZXQgdXAgdGhyb3R0bGUgY2hlY2tib3ggKilcbiAgbGV0IGNoZWNrYm94X2VsID0gZmluZF9lbF9ieV9pZCBcInRocm90dGxlXCIgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSAoZnVuIF8gLT4gb25fY2hlY2tib3hfY2hhbmdlIGNoZWNrYm94X2VsKSAoRWwuYXNfdGFyZ2V0IGNoZWNrYm94X2VsKTtcbiAgKCogU2V0IHVwIGxvYWQgcm9tIGJ1dHRvbiAqKVxuICBsZXQgaW5wdXRfZWwgPSBmaW5kX2VsX2J5X2lkIFwibG9hZC1yb21cIiBpblxuICBFdi5saXN0ZW4gRXYuY2hhbmdlIChmdW4gXyAtPiBvbl9sb2FkX3JvbSBjdHggaW1hZ2VfZGF0YSBpbnB1dF9lbCkgKEVsLmFzX3RhcmdldCBpbnB1dF9lbCk7XG4gICgqIFNldCB1cCByb20gc2VsZWN0b3IgKilcbiAgbGV0IHNlbGVjdG9yX2VsID0gZmluZF9lbF9ieV9pZCBcInJvbS1zZWxlY3RvclwiIGluXG4gIHNldF91cF9yb21fc2VsZWN0b3IgY3R4IGltYWdlX2RhdGEgc2VsZWN0b3JfZWw7XG4gICgqIExvYWQgaW5pdGlhbCByb20gKilcbiAgbGV0IHJvbSA9IExpc3QuaGQgcm9tX29wdGlvbnMgaW5cbiAgbGV0IGZ1dCA9IHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tLnBhdGggaW5cbiAgRnV0LmF3YWl0IGZ1dCAoZnVuICgpIC0+ICgpKVxuIl19
