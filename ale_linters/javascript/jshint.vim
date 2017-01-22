" Author: Chris Kyrouac - https://github.com/fijshion
" Description: JSHint for Javascript files

let g:ale_javascript_jshint_executable =
\   get(g:, 'ale_javascript_jshint_executable', 'jshint')

let g:ale_javascript_jshint_use_global =
\   get(g:, 'ale_javascript_jshint_use_global', 0)

function! ale_linters#javascript#jshint#GetExecutable(buffer) abort
    if g:ale_javascript_jshint_use_global
        return g:ale_javascript_jshint_executable
    endif

    return ale#util#ResolveLocalPath(
    \   a:buffer,
    \   'node_modules/.bin/jshint',
    \   g:ale_javascript_jshint_executable
    \)
endfunction

function! ale_linters#javascript#jshint#GetCommand(buffer) abort
    " Search for a local JShint config locaation, and default to a global one.
    let l:jshint_config = ale#util#ResolveLocalPath(
    \   a:buffer,
    \   '.jshintrc',
    \   get(g:, 'ale_jshint_config_loc', '')
    \)

    let l:command = ale_linters#javascript#jshint#GetExecutable(a:buffer)
    let l:command .= ' --reporter unix'

    if !empty(l:jshint_config)
        let l:command .= ' --config ' . fnameescape(l:jshint_config)
    endif

    let l:command .= ' -'

    return l:command
endfunction

call ale#linter#Define('javascript', {
\   'name': 'jshint',
\   'executable_callback': 'ale_linters#javascript#jshint#GetExecutable',
\   'command_callback': 'ale_linters#javascript#jshint#GetCommand',
\   'callback': 'ale#handlers#HandleUnixFormatAsError',
\})
