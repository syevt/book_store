$ ->
  bseSettingsModule = do ->
    init: ->
      return unless $('#settings').length > 0

      $('.country-select').change ->
        target = @getAttribute('data-target')
        targetInput = $("##{target}")[0]
        type = target.split('-')[0]
        countryCode = $("option.#{type}")[@selectedIndex]
                        .getAttribute('data-country-code')
        targetInput.value = '+' + countryCode

      $('#remove-account-checkbox').change ->
        $('#remove-account').toggleClass('disabled')


  bseSettingsModule.init()
