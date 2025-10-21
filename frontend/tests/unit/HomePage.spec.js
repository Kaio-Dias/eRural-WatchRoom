import { shallowMount } from '@vue/test-utils'
import HomePage from '@/views/HomePage.vue'

describe('HomePage.vue', () => {
  it('renders the component', () => {
    const wrapper = shallowMount(HomePage)
    expect(wrapper.exists()).toBe(true)
  })

  it('has a create room button', () => {
    const wrapper = shallowMount(HomePage)
    const button = wrapper.find('button')
    expect(button.exists()).toBe(true)
    expect(button.text()).toBe('Create your room')
  })

  it('redirects to room page when create room button is clicked', async () => {
    const mockRouter = {
      push: jest.fn()
    }
    const wrapper = shallowMount(HomePage, {
      global: {
        mocks: {
          $router: mockRouter
        }
      }
    })
    const button = wrapper.find('button')
    await button.trigger('click')
    expect(mockRouter.push).toHaveBeenCalledWith({ name: 'room', params: { id: '123' } })
  })
})
