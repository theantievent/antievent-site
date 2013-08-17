module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    meta:
      package: "package",
      banner : """
        /* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("m/d/yyyy") %>
           <%= pkg.homepage %>
           Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */

        """
    # =========================================================================

    source:
      coffee: [
        "src/*.coffee",
        "src/models/*.coffee",
        "src/views/*.coffee",
        "src/controllers/*.coffee"]
      sass: [
        "src/stylesheets/site.*.scss"]
      sass_files: [
        "src/stylesheets/sass/modules/*.scss",
        "src/stylesheets/sass/partials/*.scss",
        "src/stylesheets/sass/vendor/*.scss"]
      jade: [
        "src/jades/base.jade"]
      jade_files: [
        "src/jades/*.jade"]

    components:
      js: [
        "components/jquery/jquery.js",
        "components/monocle/monocle.js",
        "components/appnima.js/appnima.js",
        "components/hope/hope.js",
        "components/isotope/jquery.isotope.min.js", 
        #"components/gridalicious/jquery.grid-a-licious.min.js",
        "components/device.js/device.js"]

    # =========================================================================
    coffee:
      core: files: "build/<%=pkg.name%>.<%=pkg.version%>.debug.js": "<%= source.coffee %>"

    uglify:
      options: compress: false, banner: "<%= meta.banner %>"
      core: files: "<%=meta.package%>/javascripts/<%=pkg.name%>.<%=pkg.version%>.js": "build/<%=pkg.name%>.<%=pkg.version%>.debug.js"

    compass: 
      dist:
        options:
          sassDir: 'src/stylesheets',
          cssDir: '<%=meta.package%>/stylesheets',
          environment: 'development'
          

    jade:
      compile:
        options: data: debug: true
        files:   "<%=meta.package%>/index.html": "<%= source.jade %>"

    concat:
      js:
        src: "<%= components.js %>", dest: "<%=meta.package%>/javascripts/<%=pkg.name%>.components.js"
     

    watch:
      coffee:
        files: ["<%= source.coffee %>"]
        tasks: ["coffee", "uglify"]
      compass:
        files: ["<%= source.sass_files %>"]
        tasks: ["compass"]
      jade:
        files: ["<%= source.jade_files %>"]
        tasks: ["jade"]
      components:
        files: ["<%= components.js %>"]
        tasks: ["concat"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-compass";

  grunt.registerTask "default", [ "concat", "coffee", "uglify", "compass", "jade"]
