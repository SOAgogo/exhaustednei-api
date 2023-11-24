                            (function($) {
                                showSwal = function(type) {
                                  'use strict';
                                   if (type === 'auto-close') {
                                    swal({
                                      title: 'Click Confirm Button',
                                      text: 'It will close in 10 seconds.',
                                      timer: 10000,
                                      button: false
                                    }).then(
                                      function() {},
                                      // handling the promise rejection
                                      function(dismiss) {
                                        if (dismiss === 'timer') {
                                          console.log('I was closed by the timer')
                                        }
                                      }
                                    )
                                  }else{
                                      swal("Error occured !");
                                  } 
                                }
                              
                              })(jQuery);
                                                      
                                                      