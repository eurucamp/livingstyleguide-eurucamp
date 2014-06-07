Team Page
=========

Members
-------

~~~
@haml
@full-width
***.team-page***
  ***.team-page--container***
    %h1***.team-page--title*** Team
    ***.team-page--members***
      - 6.times do
        ***.team-page--members-item***
          ***.team-page--members-item-photo***
            %img***.team-page--members-item-photo-image***(src="images/dummy/avatar.jpg")
          %h2***.team-page--members-item-name*** Akasha
          ***.team-page--members-item-position*** Offical Cat
          %a***.team-page--members-item-link.-twitter***(href)
          %a***.team-page--members-item-link.-github***(href)
          %a***.team-page--members-item-link.-website***(href)
          %a***.team-page--members-item-link.-email***(href)
~~~


Ruby.Berlin
-----------

~~~
@haml
@full-width
.team-page
  .team-page--container
    ***.team-page--ruby-berlin***
      %h1***.team-page--ruby-berlin-title*** Ruby.Berlin
      ***.team-page--ruby-berlin-text***
        %p Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque id ullamcorper sem. Ut vestibulum vulputate nisl, id convallis velit blandit vel. Quisque non dignissim enim.
      %a***.team-page--ruby-berlin-link***(href) ruby.berlin
~~~

