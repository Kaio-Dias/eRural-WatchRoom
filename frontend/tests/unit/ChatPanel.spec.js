import { shallowMount } from '@vue/test-utils'
import ChatPanel from '@/components/ChatPanel.vue'

describe('ChatPanel.vue', () => {
  it('renders the component', () => {
    const wrapper = shallowMount(ChatPanel)
    expect(wrapper.exists()).toBe(true)
  })

  it('displays messages', () => {
    const wrapper = shallowMount(ChatPanel)
    const messages = wrapper.findAll('.message')
    expect(messages.length).toBe(2)
  })

  it('sends a message', async () => {
    const wrapper = shallowMount(ChatPanel)
    const input = wrapper.find('input[type="text"]')
    await input.setValue('New message')
    const button = wrapper.find('button')
    await button.trigger('click')
    const messages = wrapper.findAll('.message')
    expect(messages.length).toBe(3)
    expect(messages[2].text()).toContain('New message')
  })
})
