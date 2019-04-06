# Henry

Henry is a simple static site generator written in Elixir. The name Henry refers to a certain famous doctor who may or may not have some association with static site generation.

**Henry is very much a work in progress**

## Why Henry

Henry was mostly made to help me learn Elixir and as motivation to rebuild my personal site. If you are already an Elixir developer, building stuff using `mix` tasks is pretty nice. Otherwise maybe you just feel like being a hipster and eschewing the popular static site generators. If looking for a mature solution to build stuff for your job, maybe check out https://www.staticgen.com/ first :)

## Feature roadmap

- [x] page parsing / rendering
- [x] multiple layouts
- [x] copying assets from the specified theme or the root assets folder
- [x] local themes
- [x] post parsing /rendering
- [x] 'henry post' / 'henry page' to generate files
- [x] 'henry layout' to generate a basic layout
- [x] 'henry new' to generate an empty project
- [x] also works as mix tasks
- [ ] sort posts by date
- [ ] RSS feed generation
- [ ] build frontend assets with parcel
- [ ] 'henry watch' to rebuild on file change and run a dev server
- [ ] a solid default theme
- [ ] actual good SEO
- [ ] partials
- [ ] post pagination
- [ ] themes from github

## Installation

Henry supports usage as a standalone script or a set of [mix](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html) tasks.

### Prebuilt
**Prebuilt releases are coming soon.**

### From source

#### Install Elixir
To build henry you will first need to install [Elixir](https://elixir-lang.org/install.html).

#### Clone the repo
We need to clone the repo before we can do much else.

```
git clone git@github.com:TheMallen/Henry.git
```

### Install dependencies
Next we fetch our dependencies, don't worry there's only a couple.

```
mix deps.get
```

#### Option 1: registering mix tasks
In your local copy of the Henry repo

```
mix do deps.get, archive.build, archive.install
```

This will load the tasks into your local installation of `mix`. Afterwards you will be able to run henry tasks like any other `mix` command. To start, try creating a new site.

#### Option 2: building an escript
In your local copy of the Henry repo

```
mix do deps.get, escript.build
```

This will generate an [escript](https://elixirschool.com/en/lessons/advanced/escripts/) in the directory named `henry`. If you add `./henry` to your `PATH` you will be able to run it from anywhere. To start, try creating a new site.

## Usage

** In depth docs coming soon **

### As a mix task
```bash
  # bootstrap a project
  mix henry.new "My Rad Website"
  cd ./my-rad-website
  # build the static files to /dist
  mix henry.build
```

#### As an escript
```bash
  # bootstrap a project
  henry new "My Rad Website"
  cd ./my-rad-website
  # build the static files to /dist
  henry build
```
