piped_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'stream-item-factory.vala',
  'square-frame.vala',
  'video-view.vala',
  'video-grid.vala'
]

piped_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libsoup-3.0'),
  dependency('json-glib-1.0'),
]

piped_sources += gnome.compile_resources('piped-resources',
  'piped.gresource.xml',
  c_name: 'piped'
)

subdir('piped-api')

if get_option('piped_in_flatpak')
message('a')
  add_project_arguments('-D', 'PIPED_IN_FLATPAK', language: 'vala')
endif

add_project_arguments('-D', 'proot', language: 'vala')

executable('piped', piped_sources,
  dependencies: piped_deps,
       install: true,
)
