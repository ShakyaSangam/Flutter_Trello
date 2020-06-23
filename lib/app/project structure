lib/
    app/                          <--- application layer
        pages/                        <-- pages or screens
          login/                        <-- some page in the app
            login_controller.dart         <-- login controller extends `Controller`
            login_presenter.dart          <-- login presenter extends `Presenter`
            login_view.dart               <-- login view, 2 classes extend `View` and `ViewState` resp.
        widgets/                      <-- custom widgets
        utils/                        <-- utility functions/classes/constants
        navigator.dart                <-- optional application navigator
    data/                         <--- data layer
        repositories/                 <-- repositories (retrieve data, heavy processing etc..)
          data_auth_repo.dart           <-- example repo: handles all authentication
        helpers/                      <-- any helpers e.g. http helper
        constants.dart                <-- constants such as API keys, routes, urls, etc..
    device/                       <--- device layer
        repositories/                 <--- repositories that communicate with the platform e.g. GPS
        utils/                        <--- any utility classes/functions
    domain/                       <--- domain layer (business and enterprise) PURE DART
        entities/                   <--- enterprise entities (core classes of the app)
          user.dart                   <-- example entity
          manager.dart                <-- example entity
        usecases/                   <--- business processes e.g. Login, Logout, GetUser, etc..
          login_usecase.dart          <-- example usecase extends `UseCase` or `CompletableUseCase`
        repositories/               <--- abstract classes that define functionality for data and device layers
    main.dart                     <--- entry point