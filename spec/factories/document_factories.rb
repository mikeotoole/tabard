FactoryGirl.define do    
  factory :privacy_policy do
    body "Donec eget dignissim purus. Duis lacinia ullamcorper erat, non pharetra nisi mattis id. Ut ornare euismod consectetur. Cras libero magna, sodales et mattis vel, iaculis nec nisi. Sed non nibh in felis placerat egestas. Integer tristique, justo sed euismod egestas, neque neque dictum felis, at lobortis odio est viverra neque. Nulla eu arcu in eros ullamcorper imperdiet. Cras nec nibh quis felis sagittis mattis a et mi. Sed nulla orci, bibendum sed volutpat sed, dignissim in neque. Mauris nec dui magna. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus pellentesque tincidunt felis, nec scelerisque nulla varius at. Pellentesque imperdiet venenatis sem, ut sollicitudin eros tempor vitae. Donec tincidunt elementum purus tincidunt laoreet."
    sequence(:version)
    is_published true
  end
  
  factory :terms_of_service do
    body "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent a ligula vitae leo varius consequat id ut nulla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed egestas mi a lacus accumsan ultrices. Suspendisse egestas ipsum eget erat gravida et aliquet lectus cursus. Fusce egestas porttitor mi. Sed laoreet imperdiet libero, eget semper mi sollicitudin a. In tincidunt pretium tortor convallis bibendum. Curabitur non velit purus. Morbi tincidunt magna id ante lacinia lacinia. Phasellus ullamcorper nibh sed ante gravida non aliquet eros porta. Aliquam auctor rutrum velit at feugiat."
    sequence(:version)
    is_published true
  end
end