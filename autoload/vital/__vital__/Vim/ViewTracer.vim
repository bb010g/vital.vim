let s:save_cpo = &cpo
set cpo&vim

function! s:trace_window(...) abort
  let tabnr = get(a:000, 0, tabpagenr())
  let winnr = get(a:000, 1, winnr())
  return {'window': gettabwinvar(tabnr, winnr, '')}
endfunction

function! s:trace_tabpage(...) abort
  let tabnr = get(a:000, 0, tabpagenr())
  return {'tabpage': s:_gettabdict(tabnr)}
endfunction

function! s:find(handle) abort
  if has_key(a:handle, 'window')
    return s:_find_window(a:handle.window)
  elseif has_key(a:handle, 'tabpage')
    return s:_find_tabpage(a:handle.tabpage)
  endif
  return [0, 0]
endfunction

function! s:_find_window(scope_var) abort
  for tabnr in range(1, tabpagenr('$'))
    for winnr in range(1, tabpagewinnr(tabnr, '$'))
      if gettabwinvar(tabnr, winnr, '') is a:scope_var
        return [tabnr, winnr]
      endif
    endfor
  endfor
  return [0, 0]
endfunction

function! s:_find_tabpage(scope_var) abort
  for tabnr in range(1, tabpagenr('$'))
    if s:_gettabdict(tabnr) is a:scope_var
      return [tabnr, 0]
    endif
  endfor
  return [0, 0]
endfunction

function! s:exists(handle) abort
  return s:find(a:handle) != [0, 0]
endfunction

function! s:tabnr(handle) abort
  return s:find(a:handle)[0]
endfunction

function! s:winnr(handle) abort
  return s:find(a:handle)[1]
endfunction

function! s:jump(handle) abort
  let [tabnr, winnr] = s:find(a:handle)
  if tabnr == 0
    return
  endif
  call s:_move(tabnr, winnr)
endfunction

function! s:_move(tabnr, winnr) abort
  if a:tabnr != 0 && a:tabnr != tabpagenr()
    execute a:tabnr 'tabnext'
  endif
  if a:winnr != 0 && a:winnr != winnr()
    execute a:winnr 'wincmd w'
  endif
endfunction

function! s:_gettabdict(tabnr) abort
  return gettabvar(a:tabnr, '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
