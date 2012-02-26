( function( $ ) {
    
    var Explain = {

        _form  : null,
        _table : null,


        init : function( form, table ) {

            this._setForm( form );

            this._setTable( table );
        },

        _setForm : function( form ) {

            form = $( form );

            form.bind( 'submit', $.proxy( this, '_formSubmit' ) );

            form.find( 'input:radio, input:checkbox' ).each( $.proxy( function( i, input ) {

                input = $( input );

                if ( !input.attr( 'name' ).match( /^(c|ve|vi|vx|vr|vl)$/ ) ) return true;

                input.bind( 'change', $.proxy( function( e ) {

                    this._inputChange( e, input );

                }, this ) );

            }, this ) );

            this._form = form;
        },

        _setTable : function( table ) {

            table = $( table );

            this._table = table;

            this._table.find( 'tbody tr' ).each( $.proxy( function( i, row ) {

                var row = $( row );

                row.bind( 'mouseover', $.proxy( function( e ) {
                    this._mouseover( e, row );
                }, this ) );

                row.bind( 'mouseout', $.proxy( function( e ) {
                    this._mouseout( e, row );
                }, this ) );

                row.bind( 'click', $.proxy( function( e ) {
                    this._click( e, row );
                }, this ) );

            }, this ) );

        },

        _mouseover : function( e, row ) {

            row.addClass( 'hover' );

            var level = parseInt( row.attr( 'data-level' ) );

            var nodeId = row.attr( 'data-node_id' );

            row.nextAll( ).each( function( i, r ) {

                var r = $( r );

                var l = r.attr( 'data-level' )

                if ( l == level ) {

                    if ( r.hasClass( 'sp' ) || r.hasClass( 'ip' ) || r.hasClass( 'cte' ) ) return true;

                    return false;
                }

                if ( l == level + 1 ) {

                    if ( r.attr( 'data-node_parent' ) != nodeId ) return true;

                    r.addClass( 'sub-n' );
                }

            } );
        },

        _mouseout : function( e, row ) {

            row.removeClass( 'hover' );

            row.parent( ).find( '.sub-n' ).removeClass( 'sub-n' );
        },

        _click : function( e, row ) {

            var isCollapsed = row.hasClass( 'collapsed' ) ? true : false;

            var level = parseInt( row.attr( 'data-level' ) );

            var affected = 0;

            var nodeId = row.attr( 'data-node_id' );

            row.nextAll( ).each( function( i, r ) {

                var r = $( r );

                var l = r.attr( 'data-level' );

                if ( l < level )
                    return false;

                if ( l == level ) {

                    if ( row.hasClass( 'n' ) ) {

                        if ( r.hasClass( 'n' ) ) return false;

                    } else {

                        return false;

                    }
                }

                if ( l == level + 1 ) {

                    if ( !row.hasClass( 'n' ) ) {

                        if ( r.attr( 'data-node_parent' ) != nodeId )
                            return false;

                    }

                }

                affected++;

                if ( isCollapsed ) {

                    r.show( );

                    return true;
                }

                r.hide( );

                r.removeClass( 'collapsed' );

            } );

            if ( ! affected ) return;

            row.toggleClass( 'collapsed' );
        },

        colorize : function( column, a ) {

            this._table.find( 'tbody tr.n' ).map( function( i, row ) {

                row = $( row );

                row.removeClass( 'c-1 c-2 c-3 c-4 c-m' );

                var value = row.attr( 'data-' + column );

                // for "mixed"
                if ( !value ) value = column;

                row.addClass( 'c-' + value );

            } );

            this._form.find( 'input#c' + column ).attr( 'checked', 'checked' );
        },

        toggleView : function( view, link ) {

            var link = $( link );

            if ( link.hasClass( 'current' ) ) return;

            link.parents( 'ul' ).find( 'a' ).removeClass( 'current' );

            link.addClass( 'current' );

            var result = $( link.parents( 'div.result' ).get( 0 ) );

            if ( 'found' == view.toLowerCase( ) ) {
                result.find( 'div.result-found' ).show( );
                result.find( 'div.result-unassigned' ).hide( );
                result.find( 'div.result-perf' ).hide( );
                return;
            }

            if ( 'perf' == view.toLowerCase( ) ) {
                result.find( 'div.result-found' ).hide( );
                result.find( 'div.result-unassigned' ).hide( );
                result.find( 'div.result-perf' ).show( );
                return;
            }

            result.find( 'div.result-found' ).hide( );
            result.find( 'div.result-unassigned' ).show( );
            result.find( 'div.result-perf' ).hide( );
        },

        toggleCfgForm : function( link ) {

            link = $( link );

            link.parent( ).find( 'form' ).slideToggle( );

            link.toggleClass( 'collapsed' );

        },

        _formSubmit : function( ) {

            var cfg = [];

            this._form.find( 'input:radio, input:checkbox' ).each( function( i, input ) {

                input = $( input );

                // colorize
                if ( input.attr( 'name' ) == 'c' ) {

                    if ( input.is( ':checked' ) && input.attr( 'value' ).match( /^(e|i|x|m)$/ ) )
                        cfg.push( input.attr( 'name' ) + '=' + input.val( ) );

                    // next 
                    return true;
                }

                // skip
                if ( !input.attr( 'name' ).match( /^(ve|vi|vx|vr|vl)$/ ) ) return true;

                // visibility
                cfg.push( input.attr( 'name' ) + '=' + ( input.is( ':checked' ) ? 1 : 0 ) );

            } );

            // set cookie
            $.cookie( 'explain', cfg.join( '|' ) );

            // cancel form submit
            return false;
        },

        _inputChange : function( e, input ) {

            var name = input.attr( 'name' );

            // column visibility
            if ( input.attr( 'name' ).match( /^(ve|vi|vx|vr|vl)$/ ) ) {

                // column
                var c = input.attr( 'name' ).substr( 1, 1 );

                // selector
                var s = '#explain th.' + c + ', #explain td.' + c;

                if ( input.is( ':checked' ) ) {

                    $( s ).removeClass( 'tight' );

                } else {

                    $( s ).addClass( 'tight' );

                }
            }

            // colorize
            if ( input.attr( 'name' ) == 'c' ) {

                if ( !input.is( ':checked' ) ) return;

                this.colorize( input.val( ) );
            }

        }
    };

    // public
    $.fn.explain = function( method ) {

        // what are you doing?
        if (        method
          && typeof method.substr == 'function'
          &&        method.substr( 0, 1 ) == '_' ) {

            $.error( 'Method ' + method + ' is private' );
        }

        // usage: $( element/selector ).explain( 'method' [, arguments ] );
        if ( Explain[ method ] ) {

            // "proxy" to: Explain[ 'method' ]( ... )
            return Explain[method].apply( Explain, Array.prototype.slice.call( arguments, 1 ));

        // usage: $( 'table#id' ).explain( );
        } else if ( typeof method === 'object' || ! method ) {

            // "proxy" to: Explain.init( ... )
            return Explain.init.apply( Explain, arguments );

        // ...what can I do?
        } else {

            // exception
            $.error( 'Method ' +  method + ' does not exist on jQuery.explain' );
        }

  };
    $( document ).ready( function() {
        $('INPUT.auto-hint, TEXTAREA.auto-hint').focus(function(){
            if($(this).val() == $(this).attr('title')){
                $(this).val('');
                $(this).removeClass('auto-hint');
            }
        });
        $('INPUT.auto-hint, TEXTAREA.auto-hint').blur(function(){
            if($(this).val() == '' && $(this).attr('title') != ''){
                $(this).val($(this).attr('title'));
                $(this).addClass('auto-hint');
            }
        });
        $('INPUT.auto-hint, TEXTAREA.auto-hint').each(function(){
            if($(this).attr('title') == ''){ return; }
            if($(this).val() == ''){ $(this).val($(this).attr('title')); }
            else { $(this).removeClass('auto-hint'); }
        });
    });

} )( jQuery );
