---
layout: page
title: Customising templates
---

# Customising FixMyStreet templates

<p class="lead">This document explains how template inheritance works
and how to create your own custom templates.</p>

When it's building a page, FixMyStreet always looks in your cobrand's web
template directory first: if it finds a template there, it uses it, and if it
doesn't it falls back and uses the `fixmystreet` or `base` one instead.

  <svg width="300" height="250" xmlns="http://www.w3.org/2000/svg">
   <g>
    <g id="fms-template-stack">
     <g id="fms_template_base">
      <rect stroke="#000000" fill-opacity="0" id="svg_1" height="50.185915" width="262" y="187.829577" x="19" stroke-width="3" fill="#000000"/>
      <text stroke="#000000" transform="matrix(0.738028 0 0 0.738028 5.23944 6.41831)" xml:space="preserve" text-anchor="middle" font-family="Monospace" font-size="29" id="svg_2" y="288.805344" x="196.145038" stroke-width="0" fill="#000000">base</text>
     </g>
     <g id="fms-template-fixmystreet">
      <path stroke="#000000" id="svg_23" d="m137.22908,122.26178l0,44.606094l-12.435646,0l28.656044,28.656036l28.656036,-28.926376l-14.598358,0.54068l0,-45.146774l-30.278076,0.27034z" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="3" fill="#ffffff"/>
      <rect stroke="#000000" id="svg_8" height="50.185915" width="222.884508" y="100.373239" x="38.557748" stroke-width="3" fill="#ffffff"/>
      <text stroke="#000000" transform="matrix(0.738028 0 0 0.738028 5.23944 6.41831)" xml:space="preserve" text-anchor="middle" font-family="Monospace" font-size="29" id="svg_13" y="170.305344" x="196.145042" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" fill="#000000">fixmystreet</text>
      <rect stroke="#000000" id="svg_24" stroke-opacity="0" height="5.660965" width="28.055539" y="147.584084" x="138.357609" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="3" fill="#ffffff"/>
     </g>
     <g id="fms-template-cobrand">
      <path stroke="#000000" id="svg_18" d="m136.165344,36.887947l0,44.606102l-12.435638,0l28.656036,28.656036l28.656052,-28.926376l-14.598373,0.54068l0,-45.146778l-30.278076,0.270336z" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="3" fill="#ffffff"/>
      <rect stroke="#000000" id="svg_11" height="50.185915" width="174.91267" y="15.5" x="62.543663" stroke-width="3" fill="#ffffff"/>
      <text stroke="#000000" transform="matrix(0.738028 0 0 0.738028 5.23944 6.41831)" xml:space="preserve" text-anchor="middle" font-family="Monospace" font-size="29" id="svg_14" y="55.305344" x="196.145046" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" fill="#000000">your_cobrand</text>
      <rect stroke="#000000" stroke-opacity="0" id="svg_19" height="5.660965" width="28.055539" y="62.210247" x="137.293877" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="3" fill="#ffffff"/>
     </g>
    </g>
   </g>
  </svg>

To see how this works, look at some of the cobrands that already exist in the
`templates/web` directory. You need to create a new directory with your
cobrand's name: for example, do:

    mkdir templates/web/fixmypark

Then, to override an existing template, copy it into the
`templates/web/fixmypark/` directory and edit it there. You *must* use the
same directory and file names as in the parent cobrand (that is, in
`templates/web/fixmystreet` or `templates/web/base` - base might be default if
you have an older version of the code).

<div class="attention-box">
    <strong>Please note:</strong> only make template files for those things you
    need to do differently; you do not need to copy all the files into your own
    templates folder. If the change you want to make is very small to the
    base template, you could consider just adding an <code>IF</code>
    statement to that parent template instead. The
    <a href="/feeding-back/">Feeding back page</a> has more details.
</div>

For example, it's likely you'll want to change the footer template, which puts
text right at the bottom of every page. Copy the footer template into your
cobrand like this:

    cp templates/web/fixmystreet/footer.html templates/web/fixmypark/

The templates use the popular <a
href="http://www.template-toolkit.org">Template Toolkit</a> system &mdash; look
inside and you'll see HTML with placeholders like `[% THIS %]`. The `[% INCLUDE
...%]` marker pulls in another template, which, just like the footer, you can
copy into your own cobrand from `fixmystreet` or `base` and edit.

<div class="attention-box warning">
    One thing to be careful of: <strong>only edit the <code>.html</code> files</strong>. FixMyStreet
    generates <code>.ttc</code> versions, which are cached copies &mdash; don't edit these, they
    automatically get created (and overwritten) when FixMyStreet is running.
</div>

The other template you will probably make your own version of is the FAQ which
is in `templates/web/fixmystreet/faq/faq-en-gb.html`. If you translate it too,
you will need to rename it accordingly.

## Emails

There are also email templates that FixMyStreet uses when it constructs email
messages to send out. You can override these in a similar way: look in the
`templates/email` directory and you'll see cobrands overriding the templates in
`templates/email/default`.

For example, many of the email templates themselves use the small
`site-name.txt` and `signature.txt` templates, so you may want to override
these (by copying them from `templates/email/default` into your own cobrand's
directory within `templates/email`, and editing them) even if you're not
changing anything else.
