module.exports = grunt => {
  grunt.initConfig({
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script',
        },
        src: ['test/**/*.coffee'],
      },
    },
    watch: {
      files: ['Gruntfile.js', 'src/**/*.coffee', 'test/**/*.coffee'],
      tasks: ['test'],
    },
  })

  require('matchdep').filterDev(['grunt-*', '!grunt-cli']).forEach(grunt.loadNpmTasks)

  grunt.registerTask('test', ['mochaTest'])
  grunt.registerTask('test:watch', ['watch'])
  grunt.registerTask('default', ['test'])
}
