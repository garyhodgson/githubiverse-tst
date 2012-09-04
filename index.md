---

layout: default
title: Mechanical Movement \#27
author: Gary Hodgson
license: GPL3
description: An implementation of movement \#27 from ["501 Mechanical Movements"](http://books.google.de/books/about/507_Mechanical_Movements.html?id=CSH5UgzD8oIC&redir_esc=y) by Henry T. Brown
tags: [asd, qwe, yxc]
tracker: http://garyhodgson.github.com/githubiverse-tracker

---


{% include header.html %}

<h1 class="title">{{ page.title | markdownify }}</h1>
<h2 class="author">Author: {{ page.author }}</h2>
<h3 class="license">License: {{ page.license }}</h3>

<h3>Description</h3>
<div class="description">{{ page.description | markdownify }}</div>

<h5 class="tags">Tags: 
{% for tag in page.tags %}
<a href="#" class="tag">{{ tag }}</a>
{% endfor  %}
</h5>

<h3>Images</h3>
<div class="images">{% images  %}</div>

<h3>Sources</h3>
<div class="sources">{{ "" | srcs  }}</div>

<h3>STLs</h3>
<div class="stls">{{ "" | stls  }}</div>

<h4>Thingiview STL Preview:</h4>
<div id="viewer" class="stlviewer"></div>

* [Project Page](https://github.com/garyhodgson/githubiverse-tst)

