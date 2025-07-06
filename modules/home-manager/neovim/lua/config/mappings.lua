local map = vim.keymap

map.set('n', '-', 'ddkP') -- swap above
map.set('n', '_', 'ddp')  -- swap below
map.set('v', 'p', '"_dP', { noremap = true }) -- dont yank on paste
