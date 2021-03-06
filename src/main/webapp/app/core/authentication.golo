module core.authentication

import core.http
import core.users

struct authentication = { foo }

# wip : will become core.authentication

augment core.authentication.types.authentication  {

    function authenticate = |this, http| {
        let user = currentUser()

        if user:loggedIn() is true {
            http:writeToJson(map[
                  ["loggedIn", true]
                , ["nickName", user:nickName()]
                , ["admin", user:admin()]
                , ["email", user:email()]
                , ["id", user:id()]
                , ["logoutUrl", user:logoutUrl("/")]
            ])

        } else {

            http:writeToJson(map[
                  ["loggedIn", false]
                , ["loginUrl", user:loginUrl("/")]
            ])

        }
    }




    function _authenticate = |this, http| {
        let user = currentUser()

        if user:loggedIn() is true {
            http:writeToHtml("""
                <p>Hello <b>%s</b> : <a href="%s">sign out</a><br>
                admin  : %s
                email  : %s
                userId : %s
            """
                :format(
                      user:nickName()
                    , user:logoutUrl(http:uri())
                    , user:admin()
                    , user:email()
                    , user:id()
                )
            )
        } else {
            http:writeToHtml("""
                <p>Please sign in : <a href="%s">sign in</a>
            """
                :format(user:loginUrl(http:uri()))
            )
        }
    }

}
